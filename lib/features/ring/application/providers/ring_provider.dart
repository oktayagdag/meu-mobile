import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/ring/data/datasources/ring_remote_data_source.dart';
import 'package:meu_mobile/features/ring/data/repositories/ring_repository_impl.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/features/ring/domain/repositories/ring_repository.dart';

enum RingTab { routes, favorites }

extension RingTabX on RingTab {
  String get label {
    switch (this) {
      case RingTab.routes:
        return 'Tüm Hatlar';

      case RingTab.favorites:
        return 'Favoriler';
    }
  }
}

final ringRemoteDataSourceProvider = Provider<RingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(apiCacheServiceProvider);

  return DioRingRemoteDataSource(dio, cache);
});

final ringRepositoryProvider = Provider<RingRepository>((ref) {
  final remoteDataSource = ref.watch(ringRemoteDataSourceProvider);

  return RingRepositoryImpl(remoteDataSource);
});

final ringRoutesApiProvider = FutureProvider<List<RingRouteEntity>>((
  ref,
) async {
  final repository = ref.watch(ringRepositoryProvider);

  return repository.getRoutes();
});

final nextRingApiProvider = FutureProvider<RingRouteEntity?>((ref) async {
  final repository = ref.watch(ringRepositoryProvider);

  return repository.getNextRing();
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

final visibleRingRoutesProvider = FutureProvider<List<RingRouteEntity>>((
  ref,
) async {
  final routes = await ref.watch(ringRoutesApiProvider.future);

  final selectedTab = ref.watch(selectedRingTabProvider);

  switch (selectedTab) {
    case RingTab.routes:
      return routes;

    case RingTab.favorites:
      return routes.where((route) => route.isFavorite).toList();
  }
});
