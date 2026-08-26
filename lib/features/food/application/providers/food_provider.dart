import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/food/data/datasources/food_remote_data_source.dart';
import 'package:meu_mobile/features/food/data/repositories/food_repository_impl.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/food/domain/repositories/food_repository.dart';

final foodRemoteDataSourceProvider = Provider<FoodRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(apiCacheServiceProvider);

  return DioFoodRemoteDataSource(dio, cache);
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final remoteDataSource = ref.watch(foodRemoteDataSourceProvider);

  return FoodRepositoryImpl(remoteDataSource);
});

final weeklyFoodProvider = FutureProvider.autoDispose<List<FoodEntity>>((
  ref,
) async {
  final repository = ref.watch(foodRepositoryProvider);

  return repository.getWeeklyFoods();
});

final todayFoodProvider = FutureProvider.autoDispose<FoodEntity?>((ref) async {
  final repository = ref.watch(foodRepositoryProvider);

  return repository.getTodayFood();
});

final selectedFoodIndexProvider =
    NotifierProvider<SelectedFoodIndexNotifier, int>(
      SelectedFoodIndexNotifier.new,
    );

class SelectedFoodIndexNotifier extends Notifier<int> {
  @override
  int build() {
    // -1 = sayfa açıldığında bugünü otomatik seç.
    return -1;
  }

  void select(int index) {
    state = index;
  }

  void reset() {
    state = -1;
  }
}
