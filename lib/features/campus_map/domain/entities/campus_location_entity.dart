enum CampusLocationCategory {
  all,
  units,
  stops,
  atms,
  cafes,
  library,
  greenAreas,
  cafeteria,
  dormitories,
  culture,
  technology,
}

extension CampusLocationCategoryX on CampusLocationCategory {
  String get label {
    switch (this) {
      case CampusLocationCategory.all:
        return 'Tümü';

      case CampusLocationCategory.units:
        return 'Fakülteler';

      case CampusLocationCategory.stops:
        return 'Duraklar';

      case CampusLocationCategory.atms:
        return 'ATM';

      case CampusLocationCategory.cafes:
        return 'Kafeler';

      case CampusLocationCategory.library:
        return 'Kütüphane / Derslik';

      case CampusLocationCategory.greenAreas:
        return 'Yeşil Alan';

      case CampusLocationCategory.cafeteria:
        return 'Yemekhane';

      case CampusLocationCategory.dormitories:
        return 'Yurtlar';

      case CampusLocationCategory.culture:
        return 'Kültür';

      case CampusLocationCategory.technology:
        return 'Teknoloji';
    }
  }
}

class CampusLocationEntity {
  const CampusLocationEntity({
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
}
