import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/campus_map/data/datasources/campus_map_remote_data_source.dart';
import 'package:meu_mobile/features/campus_map/data/repositories/campus_map_repository_impl.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';
import 'package:meu_mobile/features/campus_map/domain/repositories/campus_map_repository.dart';

final campusMapRemoteDataSourceProvider = Provider<CampusMapRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(apiCacheServiceProvider);

  return DioCampusMapRemoteDataSource(dio, cache);
});

final campusMapRepositoryProvider = Provider<CampusMapRepository>((ref) {
  final remoteDataSource = ref.watch(campusMapRemoteDataSourceProvider);

  return CampusMapRepositoryImpl(remoteDataSource);
});

final campusLocationsProvider = FutureProvider<List<CampusLocationEntity>>((
  ref,
) async {
  final repository = ref.watch(campusMapRepositoryProvider);

  return repository.getLocations();
});

final selectedCampusLocationCategoryProvider =
    NotifierProvider<
      SelectedCampusLocationCategoryNotifier,
      CampusLocationCategory
    >(SelectedCampusLocationCategoryNotifier.new);

class SelectedCampusLocationCategoryNotifier
    extends Notifier<CampusLocationCategory> {
  @override
  CampusLocationCategory build() {
    return CampusLocationCategory.units;
  }

  void select(CampusLocationCategory category) {
    state = category;
  }
}

final selectedCampusLocationIdProvider =
    NotifierProvider<SelectedCampusLocationIdNotifier, String?>(
      SelectedCampusLocationIdNotifier.new,
    );

class SelectedCampusLocationIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void select(String? id) {
    state = id;
  }
}

final visibleCampusLocationsProvider =
    Provider<AsyncValue<List<CampusLocationEntity>>>((ref) {
      final locationsAsync = ref.watch(campusLocationsProvider);

      final selectedCategory = ref.watch(
        selectedCampusLocationCategoryProvider,
      );

      return locationsAsync.whenData((locations) {
        if (selectedCategory == CampusLocationCategory.all) {
          return locations;
        }

        return locations
            .where((location) => location.category == selectedCategory)
            .toList(growable: false);
      });
    });

final selectedCampusLocationProvider = FutureProvider<CampusLocationEntity?>((
  ref,
) async {
  final selectedId = ref.watch(selectedCampusLocationIdProvider);

  if (selectedId == null) {
    return null;
  }

  final locations = await ref.watch(campusLocationsProvider.future);

  for (final location in locations) {
    if (location.id == selectedId) {
      return location;
    }
  }

  return null;
});

final campusLocationDetailProvider =
    FutureProvider.family<CampusLocationEntity?, String>((ref, id) async {
      final repository = ref.watch(campusMapRepositoryProvider);

      return repository.getLocationById(id);
    });
