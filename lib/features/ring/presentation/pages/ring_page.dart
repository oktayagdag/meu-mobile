import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/application/providers/transit_location_provider.dart';
import 'package:meu_mobile/features/ring/application/providers/transit_provider.dart';
import 'package:meu_mobile/features/ring/domain/entities/transit_dashboard_entity.dart';
import 'package:meu_mobile/features/ring/presentation/pages/transit_bus_detail_page.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';

const _heroBackgroundColor = Color(0xFF182958);
const _outboundColor = Color(0xFFF1743A);
const _inboundColor = Color(0xFF7966D9);

class RingPage extends ConsumerWidget {
  const RingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(transitLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulaşım'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: () async {
              await ref.read(transitLocationProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: locationAsync.when(
        loading: () {
          return const AppLoadingState(message: 'Konumun belirleniyor.');
        },
        error: (error, stackTrace) {
          final message = error.toString().toLowerCase();

          final locationServiceDisabled = message.contains(
            'konum servisi kapalı',
          );

          if (locationServiceDisabled) {
            return _LocationDisabledState(
              onRetry: () async {
                await ref.read(transitLocationProvider.notifier).refresh();
              },
            );
          }

          return AppErrorState(
            error: error,
            onRetry: () {
              ref.read(transitLocationProvider.notifier).refresh();
            },
          );
        },
        data: (location) {
          return _TransitDashboardBody(location: location);
        },
      ),
    );
  }
}

class _TransitDashboardBody extends ConsumerStatefulWidget {
  const _TransitDashboardBody({required this.location});

  final TransitLocationQuery location;

  @override
  ConsumerState<_TransitDashboardBody> createState() =>
      _TransitDashboardBodyState();
}

class _TransitDashboardBodyState
    extends ConsumerState<_TransitDashboardBody> {
  String? _selectedDirectionType;

  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();

    _autoRefreshTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) {
        if (!mounted) {
          return;
        }

        ref.invalidate(
          transitDashboardProvider(
            widget.location,
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(
    covariant _TransitDashboardBody oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.location != widget.location) {
      ref.invalidate(
        transitDashboardProvider(
          widget.location,
        ),
      );
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref
        .read(
          transitLocationProvider.notifier,
        )
        .refresh();

    final latestLocation = ref
            .read(
              transitLocationProvider,
            )
            .asData
            ?.value ??
        widget.location;

    ref.invalidate(
      transitDashboardProvider(
        latestLocation,
      ),
    );

    await ref.read(
      transitDashboardProvider(
        latestLocation,
      ).future,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(
      transitDashboardProvider(
        widget.location,
      ),
    );

    return dashboardAsync.when(
      loading: () {
        return const AppLoadingState(
          message:
              'Canlı ulaşım bilgileri yükleniyor.',
        );
      },
      error: (error, stackTrace) {
        return AppErrorState(
          error: error,
          onRetry: () {
            ref.invalidate(
              transitDashboardProvider(
                widget.location,
              ),
            );
          },
        );
      },
      data: (dashboard) {
        final stops = _selectDirectionalStops(
          dashboard.nearbyStops,
        );

        final selectedStop =
            _resolveSelectedStop(
          stops,
          _selectedDirectionType,
        );

        final selectedDirectionType =
            selectedStop?.directionType;

        final selectedVehicles =
            selectedStop == null
                ? <TransitUpcomingVehicleEntity>[]
                : dashboard.upcomingVehicles
                    .where(
                      (vehicle) =>
                          vehicle.stop.stopNo ==
                          selectedStop.stopNo,
                    )
                    .toList();

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              14,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              _TransitHeroCard(
                location: widget.location,
                stops: stops,
                selectedStop: selectedStop,
                selectedDirectionType:
                    selectedDirectionType,
                upcomingVehicles:
                    selectedVehicles,
                onDirectionSelected:
                    (directionType) {
                  setState(() {
                    _selectedDirectionType =
                        directionType;
                  });
                },
              ),

              const Gap(16),

              const _LiveDataInfo(),
            ],
          ),
        );
      },
    );
  }
}

List<TransitStopEntity> _selectDirectionalStops(List<TransitStopEntity> stops) {
  TransitStopEntity? outbound;
  TransitStopEntity? inbound;

  for (final stop in stops) {
    if (stop.directionType == 'GIDIS' && outbound == null) {
      outbound = stop;
    }

    if (stop.directionType == 'GELIS' && inbound == null) {
      inbound = stop;
    }

    if (outbound != null && inbound != null) {
      break;
    }
  }

  return [?outbound, ?inbound];
}

TransitStopEntity? _resolveSelectedStop(
  List<TransitStopEntity> stops,
  String? requestedDirection,
) {
  if (stops.isEmpty) {
    return null;
  }

  if (requestedDirection != null) {
    for (final stop in stops) {
      if (stop.directionType == requestedDirection) {
        return stop;
      }
    }
  }

  // Varsayılan seçim Gidiş.
  for (final stop in stops) {
    if (stop.directionType == 'GIDIS') {
      return stop;
    }
  }

  return stops.first;
}

class _TransitHeroCard extends StatelessWidget {
  const _TransitHeroCard({
    required this.location,
    required this.stops,
    required this.selectedStop,
    required this.selectedDirectionType,
    required this.upcomingVehicles,
    required this.onDirectionSelected,
  });

  final TransitLocationQuery location;
  final List<TransitStopEntity> stops;
  final TransitStopEntity? selectedStop;
  final String? selectedDirectionType;

  final List<TransitUpcomingVehicleEntity> upcomingVehicles;

  final ValueChanged<String> onDirectionSelected;

  @override
  Widget build(BuildContext context) {
    final selectedTitle = selectedDirectionType == 'GELIS' ? 'Geliş' : 'Gidiş';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _heroBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _heroBackgroundColor.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Colors.white,
                ),
              ),

              const Gap(12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MEÜ CANLI ULAŞIM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Gap(2),
                    Text(
                      'En yakın gidiş ve geliş durakları',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              _LiveBadge(vehicleCount: upcomingVehicles.length),
            ],
          ),

          const Gap(16),

          _DirectionalStopsMap(
            location: location,
            stops: stops,
            selectedDirectionType: selectedDirectionType,
            onDirectionSelected: onDirectionSelected,
          ),

          const Gap(16),

          if (stops.isEmpty)
            const _NoStopsState()
          else
            ...stops.map((stop) {
              final selected = stop.directionType == selectedDirectionType;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _StopSummaryBlock(
                  stop: stop,
                  selected: selected,
                  onTap: () {
                    onDirectionSelected(stop.directionType);
                  },
                ),
              );
            }),

          if (stops.isNotEmpty) ...[
            const Gap(3),

            Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.60),
                ),
                const Gap(5),
                Text(
                  'Otobüsleri görmek için durağı seçebilirsin.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.60),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          const Gap(18),

          Container(height: 1, color: Colors.white.withValues(alpha: 0.13)),

          const Gap(17),

          Row(
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                size: 20,
                color: Colors.white,
              ),

              const Gap(8),

              Expanded(
                child: Text(
                  '$selectedTitle Durağına Gelmekte Olan Otobüsler',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          if (selectedStop != null) ...[
            const Gap(5),

            Text(
              selectedStop!.directionLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const Gap(12),

          if (upcomingVehicles.isEmpty)
            _HeroEmptyBusState(directionTitle: selectedTitle)
          else
            ...upcomingVehicles.map((vehicle) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _HeroVehicleRow(
                  vehicle: vehicle,
                  onTap: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(
                      MaterialPageRoute(
                        builder: (_) => TransitBusDetailPage(
                          vehicle: vehicle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _StopSummaryBlock extends StatelessWidget {
  const _StopSummaryBlock({
    required this.stop,
    required this.selected,
    required this.onTap,
  });

  final TransitStopEntity stop;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOutbound = stop.directionType == 'GIDIS';

    final accentColor = isOutbound ? _outboundColor : _inboundColor;

    final title = isOutbound ? 'EN YAKIN GİDİŞ' : 'EN YAKIN GELİŞ';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? accentColor
                  : Colors.white.withValues(alpha: 0.09),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),

                  const Spacer(),

                  if (selected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          Gap(4),
                          Text(
                            'SEÇİLİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const Gap(10),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Durak Adı: ',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: stop.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Gap(9),

              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isOutbound
                          ? Icons.arrow_forward_rounded
                          : Icons.arrow_back_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),

                  const Gap(4),

                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      Icons.directions_bus_filled_rounded,
                      size: 15,
                      color: accentColor,
                    ),
                  ),

                  const Gap(6),

                  Expanded(
                    child: Text(
                      stop.directionLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(12),

              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _HeroMetric(
                    icon: Icons.near_me_rounded,
                    text: '${stop.distanceMeters} m',
                  ),
                  _HeroMetric(
                    icon: Icons.directions_walk_rounded,
                    text: '${stop.walkingMinutes} dk yürüme',
                  ),
                  _HeroMetric(
                    icon: Icons.route_rounded,
                    text: '${stop.lines.length} hat',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectionalStopsMap extends StatelessWidget {
  const _DirectionalStopsMap({
    required this.location,
    required this.stops,
    required this.selectedDirectionType,
    required this.onDirectionSelected,
  });

  final TransitLocationQuery location;
  final List<TransitStopEntity> stops;
  final String? selectedDirectionType;

  final ValueChanged<String> onDirectionSelected;

  @override
  Widget build(BuildContext context) {
    final userPoint = LatLng(location.latitude, location.longitude);

    final coordinates = <LatLng>[
      userPoint,
      ...stops.map((stop) => LatLng(stop.latitude, stop.longitude)),
    ];

    final mapOptions = stops.isEmpty
        ? MapOptions(
            initialCenter: userPoint,
            initialZoom: 16,
            minZoom: 10,
            maxZoom: 19,
          )
        : MapOptions(
            initialCameraFit: CameraFit.coordinates(
              coordinates: coordinates,
              padding: const EdgeInsets.fromLTRB(48, 65, 48, 65),
              maxZoom: 17,
            ),
            minZoom: 10,
            maxZoom: 19,
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 285,
        child: FlutterMap(
          options: mapOptions,
          children: [
            TileLayer(
              urlTemplate:
                  'https://basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.meu_mobile',
              maxNativeZoom: 20,
              panBuffer: 0,
            ),

            MarkerLayer(
              markers: [
                Marker(
                  point: userPoint,
                  width: 46,
                  height: 46,
                  child: const _UserLocationMarker(),
                ),

                ...stops.map((stop) {
                  final selected = stop.directionType == selectedDirectionType;

                  return Marker(
                    point: LatLng(stop.latitude, stop.longitude),
                    width: 185,
                    height: 58,
                    child: _DirectionalStopMarker(
                      stop: stop,
                      selected: selected,
                      onTap: () {
                        onDirectionSelected(stop.directionType);
                      },
                    ),
                  );
                }),
              ],
            ),

            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('© OpenStreetMap contributors · © CARTO'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xFF1976D2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionalStopMarker extends StatelessWidget {
  const _DirectionalStopMarker({
    required this.stop,
    required this.selected,
    required this.onTap,
  });

  final TransitStopEntity stop;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOutbound = stop.directionType == 'GIDIS';

    final markerColor = isOutbound ? _outboundColor : _inboundColor;

    final title = isOutbound ? 'Gidiş Durağı' : 'Geliş Durağı';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: '${stop.name}\n${stop.directionLabel}',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 45 : 41,
              height: selected ? 45 : 41,
              decoration: BoxDecoration(
                color: markerColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: selected ? 4 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: markerColor.withValues(
                      alpha: selected ? 0.48 : 0.25,
                    ),
                    blurRadius: selected ? 13 : 8,
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.directions_bus_filled_rounded,
                    color: Colors.white,
                    size: 21,
                  ),

                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: markerColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isOutbound
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_back_rounded,
                        color: markerColor,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(5),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: selected
                    ? Border.all(color: markerColor, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.13),
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: markerColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  if (selected) ...[
                    const Gap(4),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: markerColor,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroVehicleRow extends StatelessWidget {
  const _HeroVehicleRow({
    required this.vehicle,
    required this.onTap,
  });

  final TransitUpcomingVehicleEntity vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isArriving = vehicle.isArriving || vehicle.minutes == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vehicle.lineNo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const Gap(11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Gap(5),

                    Text(
                      'Durak: ${vehicle.stop.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.58),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isArriving
                          ? const Color(
                              0xFF5AE68B,
                            ).withValues(
                              alpha: 0.20,
                            )
                          : Colors.white.withValues(
                              alpha: 0.13,
                            ),
                      borderRadius: BorderRadius.circular(
                        9,
                      ),
                    ),
                    child: Text(
                      vehicle.arrivalText,
                      style: TextStyle(
                        color: isArriving
                            ? const Color(
                                0xFF8DFFB4,
                              )
                            : Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const Gap(6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFF1677E8,
                      ),
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.22,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_searching_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        Gap(4),
                        Text(
                          'CANLI İZLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
                        Gap(2),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoStopsState extends StatelessWidget {
  const _NoStopsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Yakınında uygun gidiş veya geliş durağı bulunamadı.',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeroEmptyBusState extends StatelessWidget {
  const _HeroEmptyBusState({required this.directionTitle});

  final String directionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: Colors.white70, size: 19),

          const Gap(8),

          Expanded(
            child: Text(
              'Şu anda $directionTitle durağına yaklaşan aktif araç görünmüyor.',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.vehicleCount});

  final int vehicleCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF5AE68B),
              shape: BoxShape.circle,
            ),
          ),

          const Gap(6),

          Text(
            vehicleCount > 0 ? 'CANLI' : 'BAĞLI',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const Gap(5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDisabledState extends StatelessWidget {
  const _LocationDisabledState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.location_off_rounded,
                size: 38,
                color: AppColors.primary,
              ),
            ),

            const Gap(20),

            Text(
              'Konum Kapalı',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),

            const Gap(8),

            Text(
              'En yakın gidiş ve geliş duraklarını gösterebilmemiz için telefonunun konumunu açmalısın.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),

            const Gap(22),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  await Geolocator.openLocationSettings();

                  await onRetry();
                },
                icon: const Icon(Icons.location_on_rounded),
                label: const Text('Konumu Aç'),
              ),
            ),

            const Gap(8),

            TextButton(
              onPressed: onRetry,
              child: const Text('Tekrar Kontrol Et'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveDataInfo extends StatelessWidget {
  const _LiveDataInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),

          const Gap(6),

          Flexible(
            child: Text(
              'Canlı ulaşım bilgileri Mersin Büyükşehir Belediyesi verilerinden alınır.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
