class FoodEntity {
  const FoodEntity({
    required this.id,
    required this.date,
    required this.displayDate,
    required this.day,
    required this.mainDish,
    required this.firstSideDish,
    required this.vegetarianDish,
    required this.secondSideDish,
    required this.thirdItem,
    required this.meatMixGrams,
    required this.totalCalories,
    required this.isHoliday,
    required this.holidayName,
  });

  final String id;

  /// API formatı: 2026-07-28
  final String date;

  /// Kullanıcıya gösterilecek format: 28 Temmuz 2026
  final String displayDate;

  final String day;

  final String? mainDish;
  final String? firstSideDish;
  final String? vegetarianDish;
  final String? secondSideDish;
  final String? thirdItem;

  final int? meatMixGrams;
  final int? totalCalories;

  final bool isHoliday;
  final String? holidayName;

  bool get hasMenu {
    return !isHoliday &&
        [
          mainDish,
          firstSideDish,
          secondSideDish,
          thirdItem,
        ].any((item) => item != null && item.trim().isNotEmpty);
  }

  /// Eski widget'ların geçiş sürecinde çalışmaya devam etmesi için.
  List<FoodMenuItemEntity> get items {
    if (isHoliday) {
      return const [];
    }

    final result = <FoodMenuItemEntity>[];

    void addItem(
      String? name,
      String icon, {
      FoodMenuItemType type = FoodMenuItemType.standard,
    }) {
      if (name == null || name.trim().isEmpty) {
        return;
      }

      result.add(FoodMenuItemEntity(name: name, icon: icon, type: type));
    }

    addItem(mainDish, '🍽️', type: FoodMenuItemType.mainDish);

    addItem(firstSideDish, '🍚', type: FoodMenuItemType.sideDish);

    addItem(secondSideDish, '🥣', type: FoodMenuItemType.sideDish);

    addItem(thirdItem, '🥛', type: FoodMenuItemType.extra);

    return result;
  }
}

enum FoodMenuItemType { mainDish, sideDish, extra, vegetarian, standard }

class FoodMenuItemEntity {
  const FoodMenuItemEntity({
    required this.name,
    required this.icon,
    this.type = FoodMenuItemType.standard,

    // Eski kodların geçici olarak compile olmaya devam etmesi için.
    this.calories,
  });

  final String name;
  final String icon;
  final FoodMenuItemType type;

  /// Yeni API yemek bazında kalori vermiyor.
  /// Sadece geçiş uyumluluğu için tutuluyor.
  final int? calories;
}
