class FoodEntity {
  const FoodEntity({
    required this.day,
    required this.date,
    required this.items,
    this.calories,
  });

  final String day;
  final String date;
  final List<String> items;
  final int? calories;
}