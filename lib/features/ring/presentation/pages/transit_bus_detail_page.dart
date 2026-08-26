import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/application/providers/transit_location_provider.dart';
import 'package:meu_mobile/features/ring/application/providers/transit_provider.dart';
import 'package:meu_mobile/features/ring/domain/entities/transit_dashboard_entity.dart';
import 'package:meu_mobile/features/ring/domain/entities/transit_line_tracking_entity.dart';

const _detailBlue = Color(0xFF182958);

class TransitBusDetailPage extends ConsumerWidget {
  const TransitBusDetailPage({required this.vehicle, super.key});

  final TransitUpcomingVehicleEntity vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(transitLocationProvider);
    final currentLocation = locationAsync.asData?.value;
    final userPoint = currentLocation == null
        ? null
        : LatLng(currentLocation.latitude, currentLocation.longitude);

    final stopsAsync = ref.watch(transitLineStopsProvider(vehicle.lineKey));

    final vehiclesAsync = ref.watch(
      transitLineVehiclesProvider(vehicle.lineKey),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.lineNo} Hattı'),
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: () {
              ref.invalidate(transitLineStopsProvider(vehicle.lineKey));
              ref.invalidate(transitLineVehiclesProvider(vehicle.lineKey));
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          14,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _detailBlue,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _detailBlue.withValues(alpha: 0.20),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LineHeader(vehicle: vehicle, vehiclesAsync: vehiclesAsync),

                const Gap(22),

                const _SectionTitle(
                  icon: Icons.route_rounded,
                  title: 'Hat Rotası',
                ),

                const Gap(12),

                stopsAsync.when(
                  loading: () =>
                      const _LoadingBlock(text: 'Rota yükleniyor...'),
                  error: (error, stack) {
                    return _ErrorBlock(
                      text: 'Rota bilgisi alınamadı.',
                      onRetry: () {
                        ref.invalidate(
                          transitLineStopsProvider(vehicle.lineKey),
                        );
                      },
                    );
                  },
                  data: (stops) {
                    return _RouteStopsBlock(
                      stops: stops,
                      waitingStopNo: vehicle.stop.stopNo,
                    );
                  },
                ),

                const Gap(22),

                const _SectionTitle(
                  icon: Icons.location_searching_rounded,
                  title: 'Canlı Araç Takibi',
                ),

                const Gap(6),

                Text(
                  'Araç konumları yaklaşık 10 saniyede bir yenilenir.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.58),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Gap(12),

                vehiclesAsync.when(
                  loading: () =>
                      const _LoadingBlock(text: 'Canlı araçlar aranıyor...'),
                  error: (error, stack) {
                    return _ErrorBlock(
                      text: 'Canlı araç bilgisi alınamadı.',
                      onRetry: () {
                        ref.invalidate(
                          transitLineVehiclesProvider(vehicle.lineKey),
                        );
                      },
                    );
                  },
                  data: (vehicles) {
                    if (vehicles.isEmpty) {
                      return const _NoLiveVehicles();
                    }

                    return stopsAsync.when(
                      loading: () =>
                          const _LoadingBlock(text: 'Harita hazırlanıyor...'),
                      error: (_, _) => _LiveVehicleMap(
                        stops: const [],
                        vehicles: vehicles,
                        waitingStopNo: vehicle.stop.stopNo,
                        userLocation: userPoint,
                      ),
                      data: (stops) => _LiveVehicleMap(
                        stops: stops,
                        vehicles: vehicles,
                        waitingStopNo: vehicle.stop.stopNo,
                        userLocation: userPoint,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Gap(16),

          const _DataSourceInfo(),
        ],
      ),
    );
  }
}

class _LineHeader extends StatelessWidget {
  const _LineHeader({required this.vehicle, required this.vehiclesAsync});

  final TransitUpcomingVehicleEntity vehicle;

  final AsyncValue<List<TransitLiveVehicleEntity>> vehiclesAsync;

  @override
  Widget build(BuildContext context) {
    final liveCount = vehiclesAsync.asData?.value.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                vehicle.lineNo,
                style: const TextStyle(
                  color: _detailBlue,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            const Gap(13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.lineNo} HATTI',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const Gap(4),

                  Text(
                    vehicle.name,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.68),
                      fontSize: 11,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (liveCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF5AE68B).withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 7, color: Color(0xFF78F3A3)),
                    Gap(5),
                    Text(
                      'CANLI',
                      style: TextStyle(
                        color: Color(0xFF8DFFB4),
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        const Gap(16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _HeaderMetric(
              icon: Icons.schedule_rounded,
              text: vehicle.arrivalText,
            ),
            _HeaderMetric(
              icon: Icons.directions_bus_filled_rounded,
              text: '${vehicle.stop.name} durağı',
            ),
            _HeaderMetric(icon: Icons.alt_route_rounded, text: vehicle.lineKey),
          ],
        ),
      ],
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.icon, required this.text});

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
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 19),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _RouteStopsBlock extends StatelessWidget {
  const _RouteStopsBlock({required this.stops, required this.waitingStopNo});

  final List<TransitRouteStopEntity> stops;

  final String waitingStopNo;

  @override
  Widget build(BuildContext context) {
    if (stops.isEmpty) {
      return const _EmptyBlock(text: 'Bu hattın rota bilgisi bulunamadı.');
    }

    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 9),
        itemCount: stops.length,
        itemBuilder: (context, index) {
          final stop = stops[index];

          return _RouteStopRow(
            stop: stop,
            first: index == 0,
            last: index == stops.length - 1,
            waiting: stop.stopNo == waitingStopNo,
          );
        },
      ),
    );
  }
}

class _RouteStopRow extends StatelessWidget {
  const _RouteStopRow({
    required this.stop,
    required this.first,
    required this.last,
    required this.waiting,
  });

  final TransitRouteStopEntity stop;

  final bool first;
  final bool last;
  final bool waiting;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 25,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: 2,
                      color: first
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.18),
                    ),
                  ),

                  Container(
                    width: waiting ? 15 : 9,
                    height: waiting ? 15 : 9,
                    decoration: BoxDecoration(
                      color: waiting ? const Color(0xFF5AE68B) : Colors.white,
                      shape: BoxShape.circle,
                      border: waiting
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                  ),

                  Expanded(
                    child: Container(
                      width: 2,
                      color: last
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ],
              ),
            ),

            const Gap(8),

            Expanded(
              child: Text(
                stop.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: waiting ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: waiting ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),

            if (waiting)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF5AE68B).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'BU DURAK',
                  style: TextStyle(
                    color: Color(0xFF8DFFB4),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LiveVehicleMap extends StatefulWidget {
  const _LiveVehicleMap({
    required this.stops,
    required this.vehicles,
    required this.waitingStopNo,
    required this.userLocation,
  });

  final List<TransitRouteStopEntity> stops;

  final List<TransitLiveVehicleEntity> vehicles;

  final String waitingStopNo;

  final LatLng? userLocation;

  @override
  State<_LiveVehicleMap> createState() => _LiveVehicleMapState();
}

class _LiveVehicleMapState extends State<_LiveVehicleMap> {
  final MapController _mapController = MapController();

  void _goToMyLocation() {
    final location = widget.userLocation;

    if (location == null) {
      return;
    }

    _mapController.move(
      location,
      17,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validStops =
        widget.stops.where((stop) => stop.hasLocation).toList();

    final validVehicles = widget.vehicles
        .where((vehicle) => vehicle.hasLocation)
        .toList();

    final routePoints = <LatLng>[
      ...validStops.map((stop) => LatLng(stop.latitude!, stop.longitude!)),
      ...validVehicles.map(
        (vehicle) => LatLng(vehicle.latitude!, vehicle.longitude!),
      ),
    ];

    const fallback = LatLng(36.7886, 34.5386);

    final MapOptions options;

    if (routePoints.length >= 2) {
      options = MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: routePoints,
          padding: const EdgeInsets.all(35),
          maxZoom: 16.5,
        ),
        minZoom: 8,
        maxZoom: 19,
      );
    } else {
      options = MapOptions(
        initialCenter: routePoints.isNotEmpty
            ? routePoints.first
            : widget.userLocation ?? fallback,
        initialZoom: 15,
        minZoom: 8,
        maxZoom: 19,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: SizedBox(
        height: 330,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: options,
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
                    // Hattaki diğer duraklar
                    ...validStops.map((stop) {
                      final waiting = stop.stopNo == widget.waitingStopNo;

                      return Marker(
                        point: LatLng(stop.latitude!, stop.longitude!),
                        width: waiting ? 40 : 18,
                        height: waiting ? 40 : 18,
                        child: _StopMapMarker(waiting: waiting),
                      );
                    }),

                    // Canlı otobüsler
                    ...validVehicles.map((vehicle) {
                      return Marker(
                        point: LatLng(vehicle.latitude!, vehicle.longitude!),
                        width: 48,
                        height: 48,
                        child: _BusMapMarker(vehicle: vehicle),
                      );
                    }),

                    // Kullanıcının konumu
                    if (widget.userLocation != null)
                      Marker(
                        point: widget.userLocation!,
                        width: 42,
                        height: 42,
                        child: const _UserMapMarker(),
                      ),
                  ],
                ),

                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      '© OpenStreetMap contributors · © CARTO',
                    ),
                  ],
                ),
              ],
            ),

            // Aktif araç sayısı
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 7, color: Color(0xFF23B85D)),
                    const Gap(5),
                    Text(
                      '${validVehicles.length} aktif araç',
                      style: const TextStyle(
                        color: _detailBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // KONUMUM
            Positioned(
              right: 12,
              bottom: 28,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                child: InkWell(
                  onTap: widget.userLocation == null ? null : _goToMyLocation,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          size: 18,
                          color: widget.userLocation == null
                              ? Colors.grey
                              : _detailBlue,
                        ),
                        const Gap(6),
                        Text(
                          'Konumum',
                          style: TextStyle(
                            color: widget.userLocation == null
                                ? Colors.grey
                                : _detailBlue,
                            fontSize: 11,
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
        ),
      ),
    );
  }
}

class _StopMapMarker extends StatelessWidget {
  const _StopMapMarker({required this.waiting});

  final bool waiting;

  @override
  Widget build(BuildContext context) {
    // Diğer duraklar küçük nokta
    if (!waiting) {
      return Center(
        child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: _detailBlue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }

    // Kullanıcının beklediği durak:
    // Otobüs ikonu değil, özel durak tabelası.
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1743A),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 7,
          ),
        ],
      ),
      child: const Center(
        child: _BusStopSignSymbol(),
      ),
    );
  }
}

class _BusStopSignSymbol extends StatelessWidget {
  const _BusStopSignSymbol();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Durak tabelasının üst levhası
          Positioned(
            top: 1,
            child: Container(
              width: 15,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Direk
          Positioned(
            top: 12,
            bottom: 3,
            child: Container(
              width: 2.5,
              color: Colors.white,
            ),
          ),

          // Taban
          Positioned(
            bottom: 1,
            child: Container(
              width: 11,
              height: 2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMapMarker extends StatelessWidget {
  const _UserMapMarker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BusMapMarker extends StatelessWidget {
  const _BusMapMarker({required this.vehicle});

  final TransitLiveVehicleEntity vehicle;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: vehicle.plate.isEmpty ? 'Canlı otobüs' : vehicle.plate,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1677E8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.directions_bus_filled_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 17,
            height: 17,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          const Gap(10),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          TextButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
        ],
      ),
    );
  }
}

class _EmptyBlock extends StatelessWidget {
  const _EmptyBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }
}

class _NoLiveVehicles extends StatelessWidget {
  const _NoLiveVehicles();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.directions_bus_outlined, color: Colors.white70, size: 21),
          Gap(10),
          Expanded(
            child: Text(
              'Şu anda bu yönde haritada gösterilebilecek aktif araç bulunmuyor.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataSourceInfo extends StatelessWidget {
  const _DataSourceInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
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
            'Canlı araç ve rota bilgileri Mersin Büyükşehir Belediyesi verilerinden alınır.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
