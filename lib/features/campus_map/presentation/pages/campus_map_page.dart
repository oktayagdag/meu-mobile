import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_mbtiles/flutter_map_mbtiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:meu_mobile/core/maps/campus_mbtiles_loader.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/campus_map/application/providers/campus_map_provider.dart';
import 'package:meu_mobile/features/campus_map/data/campus_boundary.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/shared/widgets/states/cache_last_updated_text.dart';

class CampusMapPage extends ConsumerStatefulWidget {
  const CampusMapPage({super.key});

  @override
  ConsumerState<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends ConsumerState<CampusMapPage> {
  static final LatLngBounds _campusBounds = LatLngBounds(
    const ll.LatLng(36.7775, 34.5130),
    const ll.LatLng(36.7945, 34.5425),
  );

  final MapController _mapController = MapController();

  MbTilesTileProvider? _tileProvider;
  Object? _tileError;

  Position? _currentPosition;
  bool _isUserInsideCampus = false;

  @override
  void initState() {
    super.initState();

    _loadOfflineMap();
    _loadUserLocation();
  }

  Future<void> _loadOfflineMap() async {
    try {
      final path = await CampusMbTilesLoader.load();

      final provider = MbTilesTileProvider.fromPath(
        path: path,
        silenceTileNotFound: true,
      );

      if (!mounted) {
        provider.dispose();
        return;
      }

      setState(() {
        _tileProvider?.dispose();
        _tileProvider = provider;
        _tileError = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _tileError = error;
      });
    }
  }

  @override
  void dispose() {
    _tileProvider?.dispose();
    _mapController.dispose();

    super.dispose();
  }

  Future<void> _animateToCampus() async {
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: _campusBounds,
        padding: const EdgeInsets.all(18),
        maxZoom: 15.5,
      ),
    );
  }

  Future<void> _loadUserLocation({bool showError = false}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (showError && mounted) {
          _showLocationMessage('Telefonun konum servisi kapalı.');
        }

        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (showError && mounted) {
          _showLocationMessage('Konum izni verilmedi.');
        }

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      final point = ll.LatLng(position.latitude, position.longitude);

      final insideCampus = _isPointInsidePolygon(point);

      if (!mounted) {
        return;
      }

      setState(() {
        _currentPosition = position;
        _isUserInsideCampus = insideCampus;
      });
    } catch (_) {
      if (showError && mounted) {
        _showLocationMessage('Konum bilgisi alınamadı.');
      }
    }
  }

  Future<void> _goToMyLocation() async {
    if (_currentPosition == null) {
      await _loadUserLocation(showError: true);
    }

    final position = _currentPosition;

    if (position == null) {
      return;
    }

    if (!_isUserInsideCampus) {
      if (mounted) {
        _showLocationMessage(
          'Şu anda Çiftlikköy Kampüsü dışında görünüyorsun.',
        );
      }

      await _animateToCampus();
      return;
    }

    _mapController.move(ll.LatLng(position.latitude, position.longitude), 17);
  }

  void _showLocationMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isPointInsidePolygon(ll.LatLng point) {
    final polygon = campusBoundary;

    var inside = false;

    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;

      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      final intersects =
          ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);

      if (intersects) {
        inside = !inside;
      }
    }

    return inside;
  }

  Future<void> _refreshLocations() async {
    ref.invalidate(campusLocationsProvider);
    ref.invalidate(selectedCampusLocationProvider);

    await ref.read(campusLocationsProvider.future);
  }

  void _selectCategory(CampusLocationCategory category) {
    ref.read(selectedCampusLocationCategoryProvider.notifier).select(category);

    ref.read(selectedCampusLocationIdProvider.notifier).select(null);

    _zoomOutSlightlyForCategory();
  }

  void _zoomOutSlightlyForCategory() {
    final camera = _mapController.camera;

    final targetZoom = (camera.zoom - 0.25).clamp(14.0, 19.0).toDouble();

    _mapController.move(camera.center, targetZoom);
  }

  void _selectLocation(CampusLocationEntity location) {
    ref.read(selectedCampusLocationIdProvider.notifier).select(location.id);

    _mapController.move(ll.LatLng(location.latitude, location.longitude), 17);
  }

  Future<void> _startDirections(CampusLocationEntity location) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${location.latitude},${location.longitude}'
      '&travelmode=walking',
    );

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  CampusLocationEntity? _findSelectedLocation(
    List<CampusLocationEntity> locations,
    String? selectedId,
  ) {
    if (selectedId == null) {
      return null;
    }

    for (final location in locations) {
      if (location.id == selectedId) {
        return location;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCampusLocationCategoryProvider);

    final selectedLocationId = ref.watch(selectedCampusLocationIdProvider);

    final visibleLocationsAsync = ref.watch(visibleCampusLocationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kampüs Haritası')),
      body: RefreshIndicator(
        onRefresh: _refreshLocations,
        child: visibleLocationsAsync.when(
          loading: () =>
              const AppLoadingState(message: 'Kampüs konumları yükleniyor...'),
          error: (error, stackTrace) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              AppErrorState(
                error: error,
                onRetry: () {
                  ref.invalidate(campusLocationsProvider);
                  ref.invalidate(visibleCampusLocationsProvider);
                  ref.invalidate(selectedCampusLocationProvider);
                },
              ),
            ],
          ),
          data: (visibleLocations) {
            final selectedLocation = _findSelectedLocation(
              visibleLocations,
              selectedLocationId,
            );

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CacheLastUpdatedText(
                    cacheKey: CacheKeys.campusLocations,
                  ),
                  const Gap(AppSpacing.xs),
                  _OfflineCampusMapCard(
                    mapController: _mapController,
                    tileProvider: _tileProvider,
                    mapError: _tileError,
                    campusBounds: _campusBounds,
                    locations: visibleLocations,
                    selectedLocation: selectedLocation,
                    userLocation:
                        _isUserInsideCampus && _currentPosition != null
                        ? ll.LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          )
                        : null,
                    userInsideCampus: _isUserInsideCampus,
                    onRetryMap: _loadOfflineMap,
                    onLocationTap: _selectLocation,
                    onMyLocationTap: _goToMyLocation,
                  ),
                  const Gap(AppSpacing.md),
                  _CampusCategoryBar(
                    selectedCategory: selectedCategory,
                    onSelected: _selectCategory,
                  ),
                  const Gap(AppSpacing.md),
                  _CampusLocationHorizontalList(
                    locations: visibleLocations,
                    selectedLocation: selectedLocation,
                    onLocationTap: _selectLocation,
                  ),
                  if (selectedLocation != null) ...[
                    const Gap(AppSpacing.md),
                    _SelectedLocationPanel(
                      location: selectedLocation,
                      onDirectionsTap: () {
                        _startDirections(selectedLocation);
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OfflineCampusMapCard extends StatelessWidget {
  const _OfflineCampusMapCard({
    required this.mapController,
    required this.tileProvider,
    required this.mapError,
    required this.campusBounds,
    required this.locations,
    required this.selectedLocation,
    required this.userLocation,
    required this.userInsideCampus,
    required this.onRetryMap,
    required this.onLocationTap,
    required this.onMyLocationTap,
  });

  final MapController mapController;
  final MbTilesTileProvider? tileProvider;
  final Object? mapError;
  final LatLngBounds campusBounds;

  final List<CampusLocationEntity> locations;
  final CampusLocationEntity? selectedLocation;

  final ll.LatLng? userLocation;
  final bool userInsideCampus;

  final VoidCallback onRetryMap;

  final ValueChanged<CampusLocationEntity> onLocationTap;
  final VoidCallback onMyLocationTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: SizedBox(height: 410, child: _buildContent(context)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (mapError != null) {
      return Container(
        color: const Color(0xFFECEFF3),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 42, color: Color(0xFF182958)),
            const Gap(12),
            const Text(
              'Kampüs haritası açılamadı.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const Gap(12),
            TextButton.icon(
              onPressed: onRetryMap,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    final provider = tileProvider;

    if (provider == null) {
      return const ColoredBox(
        color: Color(0xFFECEFF3),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: const ll.LatLng(36.7854, 34.5300),

            initialZoom: 14.8,

            minZoom: 14,
            maxZoom: 19,

            backgroundColor: const Color(0xFFE9EDF2),

            cameraConstraint: CameraConstraint.containCenter(
              bounds: campusBounds,
            ),

            interactionOptions: const InteractionOptions(
              flags:
                  InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation |
                  InteractiveFlag.pinchMove |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom,
            ),

            keepAlive: true,
          ),
          children: [
            TileLayer(
              tileProvider: provider,

              minZoom: 14,
              maxZoom: 19,

              minNativeZoom: 14,
              maxNativeZoom: 19,

              tileDisplay: const TileDisplay.instantaneous(),
            ),

            MarkerLayer(
              markers: [
                ...locations.map((location) => _buildLocationMarker(location)),

                if (userLocation != null) _buildUserMarker(userLocation!),
              ],
            ),
          ],
        ),

        Positioned(left: 12, top: 12, child: _CampusMapLabel()),

        Positioned(
          left: 10,
          bottom: 10,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '© OpenStreetMap contributors',
                style: TextStyle(
                  color: Color(0xFF58606B),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          right: 14,
          bottom: 14,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            elevation: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onMyLocationTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.my_location_rounded,
                      color: userInsideCampus
                          ? const Color(0xFF1976D2)
                          : const Color(0xFF182958),
                      size: 19,
                    ),
                    const Gap(6),
                    const Text(
                      'Konumum',
                      style: TextStyle(
                        color: Color(0xFF182958),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Marker _buildLocationMarker(CampusLocationEntity location) {
    final selected = selectedLocation?.id == location.id;

    final color = _categoryColor(location.category);

    return Marker(
      point: ll.LatLng(location.latitude, location.longitude),

      // Marker alanı her zoom seviyesinde sabit.
      width: 48,
      height: 48,

      // Koordinat pinin tam merkezine sabitlenir.
      alignment: Alignment.center,

      child: Builder(
        builder: (context) {
          final zoom = MapCamera.of(context).zoom;

          final double markerSize;

          if (zoom < 15.9) {
            markerSize = selected ? 30 : 24;
          } else if (zoom < 16.8) {
            markerSize = selected ? 38 : 32;
          } else {
            markerSize = selected ? 46 : 40;
          }

          final iconSize = markerSize * 0.52;

          final borderWidth = zoom < 15.9
              ? 1.8
              : selected
              ? 3.0
              : 2.5;

          return SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Etiket yukarı taşar ancak markerın
                // koordinat merkezini değiştirmez.
                if (selected)
                  Positioned(
                    left: -86,
                    width: 220,
                    bottom: 24 + (markerSize / 2) + 6,
                    child: Center(
                      child: _SelectedMapLocationLabel(location: location),
                    ),
                  ),

                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onLocationTap(location);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    width: markerSize,
                    height: markerSize,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF182958) : color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: borderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: selected
                                ? 0.25
                                : zoom < 15.9
                                ? 0.12
                                : 0.20,
                          ),
                          blurRadius: selected ? 12 : 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      _categoryIcon(location.category),
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Marker _buildUserMarker(ll.LatLng location) {
    return Marker(
      point: location,
      width: 30,
      height: 30,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2).withValues(alpha: 0.22),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
        return Icons.location_on_rounded;

      case CampusLocationCategory.units:
        return Icons.school_rounded;

      case CampusLocationCategory.stops:
        return Icons.directions_bus_rounded;

      case CampusLocationCategory.atms:
        return Icons.local_atm_rounded;

      case CampusLocationCategory.cafes:
        return Icons.local_cafe_rounded;

      case CampusLocationCategory.library:
        return Icons.local_library_rounded;

      case CampusLocationCategory.greenAreas:
        return Icons.park_rounded;

      case CampusLocationCategory.cafeteria:
        return Icons.restaurant_menu_rounded;

      case CampusLocationCategory.dormitories:
        return Icons.apartment_rounded;

      case CampusLocationCategory.culture:
        return Icons.theater_comedy_rounded;

      case CampusLocationCategory.technology:
        return Icons.memory_rounded;
    }
  }

  Color _categoryColor(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
      case CampusLocationCategory.units:
        return const Color(0xFF182958);

      case CampusLocationCategory.stops:
        return AppColors.success;

      case CampusLocationCategory.atms:
        return AppColors.error;

      case CampusLocationCategory.cafes:
      case CampusLocationCategory.cafeteria:
        return AppColors.warning;

      case CampusLocationCategory.library:
        return AppColors.secondary;

      case CampusLocationCategory.greenAreas:
        return const Color(0xFF2E9D57);

      case CampusLocationCategory.dormitories:
        return const Color(0xFF536DFE);

      case CampusLocationCategory.culture:
        return const Color(0xFF9C4DCC);

      case CampusLocationCategory.technology:
        return const Color(0xFF008C95);
    }
  }
}

class _SelectedMapLocationLabel extends StatelessWidget {
  const _SelectedMapLocationLabel({required this.location});

  final CampusLocationEntity location;

  static const Color _orange = Color(0xFFF1743A);
  static const Color _lightOrange = Color(0xFFFFF1E9);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 90, maxWidth: 210),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _lightOrange,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _orange, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _orange.withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            location.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _orange,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
        ),

        Transform.translate(
          offset: const Offset(0, -4),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: _lightOrange,
                border: Border(
                  right: BorderSide(color: _orange, width: 1.2),
                  bottom: BorderSide(color: _orange, width: 1.2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CampusMapLabel extends StatelessWidget {
  const _CampusMapLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded, size: 15, color: Color(0xFF182958)),
          Gap(6),
          Text(
            'Çiftlikköy Kampüsü',
            style: TextStyle(
              color: Color(0xFF182958),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusCategoryBar extends StatelessWidget {
  const _CampusCategoryBar({
    required this.selectedCategory,
    required this.onSelected,
  });

  final CampusLocationCategory selectedCategory;
  final ValueChanged<CampusLocationCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = [
      CampusLocationCategory.units,
      CampusLocationCategory.atms,
      CampusLocationCategory.cafes,
      CampusLocationCategory.library,
      CampusLocationCategory.greenAreas,
      CampusLocationCategory.cafeteria,
      CampusLocationCategory.dormitories,
      CampusLocationCategory.culture,
      CampusLocationCategory.technology,
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) {
            return const SizedBox(width: AppSpacing.sm);
          },
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category;

            return _CategoryButton(
              category: category,
              selected: isSelected,
              onTap: () => onSelected(category),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final CampusLocationCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category);

    return InkWell(
      borderRadius: AppRadius.md,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.10),
          borderRadius: AppRadius.md,
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.16),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _categoryIcon(category),
              size: 18,
              color: selected ? Colors.white : color,
            ),
            const Gap(AppSpacing.xs),
            Text(
              category.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
        return Icons.apps_rounded;
      case CampusLocationCategory.units:
        return Icons.school_rounded;
      case CampusLocationCategory.stops:
        return Icons.directions_bus_rounded;
      case CampusLocationCategory.atms:
        return Icons.local_atm_rounded;
      case CampusLocationCategory.cafes:
        return Icons.local_cafe_rounded;
      case CampusLocationCategory.library:
        return Icons.local_library_rounded;
      case CampusLocationCategory.greenAreas:
        return Icons.park_rounded;
      case CampusLocationCategory.cafeteria:
        return Icons.restaurant_menu_rounded;
      case CampusLocationCategory.dormitories:
        return Icons.apartment_rounded;
      case CampusLocationCategory.culture:
        return Icons.theater_comedy_rounded;
      case CampusLocationCategory.technology:
        return Icons.memory_rounded;
    }
  }

  Color _categoryColor(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
        return AppColors.primary;
      case CampusLocationCategory.units:
        return AppColors.primary;
      case CampusLocationCategory.stops:
        return AppColors.success;
      case CampusLocationCategory.atms:
        return AppColors.error;
      case CampusLocationCategory.cafes:
        return AppColors.warning;
      case CampusLocationCategory.library:
        return AppColors.secondary;
      case CampusLocationCategory.cafeteria:
        return AppColors.warning;
      case CampusLocationCategory.greenAreas:
        return const Color(0xFF2E9D57);
      case CampusLocationCategory.dormitories:
        return const Color(0xFF536DFE);
      case CampusLocationCategory.culture:
        return const Color(0xFF9C4DCC);
      case CampusLocationCategory.technology:
        return const Color(0xFF008C95);
    }
  }
}

class _SelectedLocationPanel extends StatelessWidget {
  const _SelectedLocationPanel({
    required this.location,
    required this.onDirectionsTap,
  });

  final CampusLocationEntity location;
  final VoidCallback onDirectionsTap;

  static const Color _orange = Color(0xFFF1743A);
  static const Color _lightOrange = Color(0xFFFFF1E9);
  static const Color _navy = Color(0xFF182958);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _lightOrange,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _orange.withValues(alpha: 0.30),
                  ),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: _orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      location.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _navy.withValues(alpha: 0.62),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: Material(
              color: _orange,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onDirectionsTap,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Yol Tarifi Başlat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusLocationHorizontalList extends StatelessWidget {
  const _CampusLocationHorizontalList({
    required this.locations,
    required this.selectedLocation,
    required this.onLocationTap,
  });

  final List<CampusLocationEntity> locations;
  final CampusLocationEntity? selectedLocation;
  final ValueChanged<CampusLocationEntity> onLocationTap;

  @override
  Widget build(BuildContext context) {
    if (locations.isEmpty) {
      return const EmptyState(
        title: 'Konum bulunamadı',
        description:
            'Seçili kategoriye uygun kampüs konumu bulunmuyor.',
        icon: Icons.location_off_rounded,
      );
    }

    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        itemCount: locations.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 8,
          );
        },
        itemBuilder: (context, index) {
          final location = locations[index];

          final isSelected =
              selectedLocation?.id == location.id;

          return _CampusLocationMiniCard(
            location: location,
            selected: isSelected,
            onTap: () {
              onLocationTap(location);
            },
          );
        },
      ),
    );
  }
}

class _CampusLocationMiniCard extends StatelessWidget {
  const _CampusLocationMiniCard({
    required this.location,
    required this.selected,
    required this.onTap,
  });

  final CampusLocationEntity location;
  final bool selected;
  final VoidCallback onTap;

  static const Color _orange = Color(
    0xFFF1743A,
  );

  static const Color _lightOrange = Color(
    0xFFFFF1E9,
  );

  static const Color _navy = Color(
    0xFF182958,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(
            16,
          ),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? _lightOrange
                  : Colors.white,
              borderRadius: BorderRadius.circular(
                16,
              ),
              border: Border.all(
                color: selected
                    ? _orange
                    : _navy.withValues(
                        alpha: 0.10,
                      ),
                width: selected ? 1.4 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? _orange.withValues(
                          alpha: 0.14,
                        )
                      : Colors.black.withValues(
                          alpha: 0.035,
                        ),
                  blurRadius: selected ? 10 : 7,
                  offset: const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? _orange
                        : _navy.withValues(
                            alpha: 0.09,
                          ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Icon(
                    _categoryIcon(
                      location.category,
                    ),
                    color: selected
                        ? Colors.white
                        : _navy,
                    size: 17,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    location.name,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? _orange
                          : _navy,
                      fontSize: 11,
                      height: 1.15,
                      fontWeight: selected
                          ? FontWeight.w900
                          : FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(
    CampusLocationCategory category,
  ) {
    switch (category) {
      case CampusLocationCategory.all:
        return Icons.map_rounded;

      case CampusLocationCategory.units:
        return Icons.school_rounded;

      case CampusLocationCategory.stops:
        return Icons.directions_bus_rounded;

      case CampusLocationCategory.atms:
        return Icons.local_atm_rounded;

      case CampusLocationCategory.cafes:
        return Icons.local_cafe_rounded;

      case CampusLocationCategory.library:
        return Icons.local_library_rounded;

      case CampusLocationCategory.greenAreas:
        return Icons.park_rounded;

      case CampusLocationCategory.cafeteria:
        return Icons.restaurant_menu_rounded;

      case CampusLocationCategory.dormitories:
        return Icons.apartment_rounded;

      case CampusLocationCategory.culture:
        return Icons.theater_comedy_rounded;

      case CampusLocationCategory.technology:
        return Icons.memory_rounded;
    }
  }
}
