import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

enum RingTab {
  routes,
  favorites,
}

final ringRoutesProvider = Provider<List<RingRouteEntity>>((ref) {
  return const [
    RingRouteEntity(
      from: 'Mühendislik',
      to: 'Çiftlikköy',
      remainingMinute: 14,
      frequencyText: 'Her 30 dakikada bir',
      isFavorite: true,
    ),
    RingRouteEntity(
      from: 'Çiftlikköy',
      to: 'Mühendislik',
      remainingMinute: 22,
      frequencyText: 'Her 30 dakikada bir',
      isFavorite: true,
    ),
    RingRouteEntity(
      from: 'Merkez',
      to: 'Mühendislik',
      remainingMinute: 30,
      frequencyText: 'Her 45 dakikada bir',
    ),
    RingRouteEntity(
      from: 'Mühendislik',
      to: 'Tıp',
      remainingMinute: 45,
      frequencyText: 'Her 60 dakikada bir',
    ),
    RingRouteEntity(
      from: 'Tıp',
      to: 'Mühendislik',
      remainingMinute: 55,
      frequencyText: 'Her 60 dakikada bir',
    ),
  ];
});

final selectedRingTabProvider =
    NotifierProvider<SelectedRingTabNotifier, RingTab>(
  SelectedRingTabNotifier.new,
);

class SelectedRingTabNotifier extends Notifier<RingTab> {
  @override
  RingTab build() {
    return RingTab.routes;
  }

  void select(RingTab tab) {
    state = tab;
  }
}

final visibleRingRoutesProvider = Provider<List<RingRouteEntity>>((ref) {
  final routes = ref.watch(ringRoutesProvider);
  final selectedTab = ref.watch(selectedRingTabProvider);

  if (selectedTab == RingTab.favorites) {
    return routes.where((route) => route.isFavorite).toList();
  }

  return routes;
});