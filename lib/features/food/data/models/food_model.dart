import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

class FoodModel extends FoodEntity {
  const FoodModel({
    required super.id,
    required super.date,
    required super.displayDate,
    required super.day,
    required super.mainDish,
    required super.firstSideDish,
    required super.vegetarianDish,
    required super.secondSideDish,
    required super.thirdItem,
    required super.meatMixGrams,
    required super.totalCalories,
    required super.isHoliday,
    required super.holidayName,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      displayDate: json['displayDate']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      mainDish: _nullableString(json['mainDish']),
      firstSideDish: _nullableString(json['firstSideDish']),
      vegetarianDish: _nullableString(json['vegetarianDish']),
      secondSideDish: _nullableString(json['secondSideDish']),
      thirdItem: _nullableString(json['thirdItem']),
      meatMixGrams: _nullableInt(json['meatMixGrams']),
      totalCalories: _nullableInt(json['totalCalories']),
      isHoliday: json['isHoliday'] == true,
      holidayName: _nullableString(json['holidayName']),
    );
  }

  static String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }
}
