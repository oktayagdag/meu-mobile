import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

final weeklyFoodProvider = Provider<List<FoodEntity>>((ref) {
  return const [
    FoodEntity(
      day: 'Pazartesi',
      date: '28 Haziran 2024',
      totalCalories: 820,
      items: [
        FoodMenuItemEntity(
          name: 'Mercimek Çorbası',
          calories: 120,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Tavuk Sote',
          calories: 320,
          icon: '🍗',
        ),
        FoodMenuItemEntity(
          name: 'Pilav',
          calories: 260,
          icon: '🍚',
        ),
        FoodMenuItemEntity(
          name: 'Ayran',
          calories: 120,
          icon: '🥛',
        ),
      ],
    ),
    FoodEntity(
      day: 'Salı',
      date: '29 Haziran 2024',
      totalCalories: 890,
      items: [
        FoodMenuItemEntity(
          name: 'Ezogelin Çorbası',
          calories: 130,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Köfte',
          calories: 360,
          icon: '🍖',
        ),
        FoodMenuItemEntity(
          name: 'Makarna',
          calories: 280,
          icon: '🍝',
        ),
        FoodMenuItemEntity(
          name: 'Yoğurt',
          calories: 120,
          icon: '🥛',
        ),
      ],
    ),
    FoodEntity(
      day: 'Çarşamba',
      date: '30 Haziran 2024',
      totalCalories: 700,
      items: [
        FoodMenuItemEntity(
          name: 'Mercimek Çorbası',
          calories: 120,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Tavuk Sote',
          calories: 320,
          icon: '🍗',
        ),
        FoodMenuItemEntity(
          name: 'Pirinç Pilavı',
          calories: 200,
          icon: '🍚',
        ),
        FoodMenuItemEntity(
          name: 'Ayran',
          calories: 60,
          icon: '🥛',
        ),
      ],
    ),
    FoodEntity(
      day: 'Perşembe',
      date: '1 Temmuz 2024',
      totalCalories: 910,
      items: [
        FoodMenuItemEntity(
          name: 'Domates Çorbası',
          calories: 140,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Tavuk Döner',
          calories: 380,
          icon: '🍗',
        ),
        FoodMenuItemEntity(
          name: 'Pirinç Pilavı',
          calories: 230,
          icon: '🍚',
        ),
        FoodMenuItemEntity(
          name: 'Ayran',
          calories: 160,
          icon: '🥛',
        ),
      ],
    ),
    FoodEntity(
      day: 'Cuma',
      date: '2 Temmuz 2024',
      totalCalories: 760,
      items: [
        FoodMenuItemEntity(
          name: 'Tarhana Çorbası',
          calories: 120,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Sebzeli Güveç',
          calories: 290,
          icon: '🥘',
        ),
        FoodMenuItemEntity(
          name: 'Makarna',
          calories: 250,
          icon: '🍝',
        ),
        FoodMenuItemEntity(
          name: 'Meyve',
          calories: 100,
          icon: '🍎',
        ),
      ],
    ),
  ];
});

final selectedFoodIndexProvider =
    NotifierProvider<SelectedFoodIndexNotifier, int>(
  SelectedFoodIndexNotifier.new,
);

class SelectedFoodIndexNotifier extends Notifier<int> {
  @override
  int build() => 2;

  void select(int index) {
    state = index;
  }
}

final selectedFoodProvider = Provider<FoodEntity>((ref) {
  final foods = ref.watch(weeklyFoodProvider);
  final selectedIndex = ref.watch(selectedFoodIndexProvider);

  if (selectedIndex < 0 || selectedIndex >= foods.length) {
    return foods.first;
  }

  return foods[selectedIndex];
});