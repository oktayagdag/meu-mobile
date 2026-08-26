import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

abstract interface class FoodRepository {
  Future<List<FoodEntity>> getWeeklyFoods();

  Future<FoodEntity?> getTodayFood();
}
