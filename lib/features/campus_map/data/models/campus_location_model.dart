import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';

class CampusLocationModel {
  const CampusLocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String description;
  final CampusLocationCategory category;
  final double latitude;
  final double longitude;

  factory CampusLocationModel.fromJson(Map<String, dynamic> json) {
    return CampusLocationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: _categoryFromValue(json['category']?.toString()),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }

  CampusLocationEntity toEntity() {
    return CampusLocationEntity(
      id: id,
      name: name,
      description: description,
      category: category,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static CampusLocationCategory _categoryFromValue(String? value) {
    switch (_normalize(value)) {
      case 'units':
      case 'unit':
      case 'birimler':
      case 'fakulteler':
        return CampusLocationCategory.units;

      case 'stops':
      case 'stop':
      case 'duraklar':
      case 'durak':
        return CampusLocationCategory.stops;

      case 'atms':
      case 'atm':
        return CampusLocationCategory.atms;

      case 'cafes':
      case 'cafe':
      case 'kafeler':
      case 'kafe':
        return CampusLocationCategory.cafes;

      case 'library':
      case 'kutuphane':
        return CampusLocationCategory.library;

      case 'greenareas':
      case 'greenAreas':
      case 'yesilalan':
      case 'yesilalanlar':
        return CampusLocationCategory.greenAreas;

      case 'cafeteria':
      case 'yemekhane':
        return CampusLocationCategory.cafeteria;

      case 'dormitories':
      case 'dormitory':
      case 'yurtlar':
      case 'yurt':
        return CampusLocationCategory.dormitories;

      case 'culture':
      case 'kultur':
        return CampusLocationCategory.culture;

      case 'technology':
      case 'teknoloji':
        return CampusLocationCategory.technology;

      default:
        return CampusLocationCategory.units;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
  }

  static String _normalize(String? value) {
    return (value ?? '')
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .trim();
  }
}
