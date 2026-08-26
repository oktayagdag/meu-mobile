import 'package:meu_mobile/features/food/data/datasources/food_remote_data_source.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/food/domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  const FoodRepositoryImpl(this._remoteDataSource);

  final FoodRemoteDataSource _remoteDataSource;

  @override
  Future<List<FoodEntity>> getWeeklyFoods() async {
    final models = await _remoteDataSource.fetchWeeklyFoods();

    return models;
  }

  @override
  Future<FoodEntity?> getTodayFood() async {
    final model = await _remoteDataSource.fetchTodayFood();

    return model;
  }
}
