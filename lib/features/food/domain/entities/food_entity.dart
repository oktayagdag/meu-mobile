class FoodEntity {
  const FoodEntity({
    required this.day,
    required this.date,
    required this.items,
    required this.totalCalories,
  });

  final String day;
  final String date;
  final List<FoodMenuItemEntity> items;
  final int totalCalories;
}

class FoodMenuItemEntity {
  const FoodMenuItemEntity({
    required this.name,
    required this.calories,
    required this.icon,
  });

  final String name;
  final int calories;
  final String icon;
}