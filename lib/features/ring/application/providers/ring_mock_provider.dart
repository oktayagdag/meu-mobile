import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

final ringRoutesProvider = Provider<List<RingRouteEntity>>((ref) {
  return const [
    RingRouteEntity(
      from: 'Mühendislik',
      to: 'Çiftlikköy',
      time: '14:20',
      remainingMinute: 12,
    ),
    RingRouteEntity(
      from: 'Çiftlikköy',
      to: 'Mühendislik',
      time: '14:40',
      remainingMinute: 32,
    ),
    RingRouteEntity(
      from: 'Mühendislik',
      to: 'Tıp Fakültesi',
      time: '15:00',
      remainingMinute: 52,
    ),
    RingRouteEntity(
      from: 'Tıp Fakültesi',
      to: 'Çiftlikköy',
      time: '15:20',
      remainingMinute: 72,
    ),
  ];
});

final nextRingProvider = Provider<RingRouteEntity>((ref) {
  final routes = ref.watch(ringRoutesProvider);
  return routes.first;
});