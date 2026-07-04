import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

final weeklyFoodProvider = Provider<List<FoodEntity>>((ref) {
  return const [
    FoodEntity(
      day: 'Pazartesi',
      date: '29 Haziran',
      items: ['Mercimek Çorbası', 'Tavuk Sote', 'Pilav', 'Ayran'],
      calories: 820,
    ),
    FoodEntity(
      day: 'Salı',
      date: '30 Haziran',
      items: ['Ezogelin Çorbası', 'Köfte', 'Makarna', 'Yoğurt'],
      calories: 890,
    ),
    FoodEntity(
      day: 'Çarşamba',
      date: '1 Temmuz',
      items: ['Yayla Çorbası', 'Etli Nohut', 'Bulgur Pilavı', 'Salata'],
      calories: 760,
    ),
    FoodEntity(
      day: 'Perşembe',
      date: '2 Temmuz',
      items: ['Domates Çorbası', 'Tavuk Döner', 'Pirinç Pilavı', 'Ayran'],
      calories: 910,
    ),
    FoodEntity(
      day: 'Cuma',
      date: '3 Temmuz',
      items: ['Tarhana Çorbası', 'Sebzeli Güveç', 'Makarna', 'Meyve'],
      calories: 700,
    ),
  ];
});

final todayFoodProvider = Provider<FoodEntity>((ref) {
  final weeklyFoods = ref.watch(weeklyFoodProvider);
  return weeklyFoods[3];
});