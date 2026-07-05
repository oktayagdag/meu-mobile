enum CampusLocationCategory {
  all,
  faculty,
  library,
  cafeteria,
  transport,
  administrative,
  social,
}

extension CampusLocationCategoryX on CampusLocationCategory {
  String get label {
    switch (this) {
      case CampusLocationCategory.all:
        return 'Tümü';
      case CampusLocationCategory.faculty:
        return 'Fakülte';
      case CampusLocationCategory.library:
        return 'Kütüphane';
      case CampusLocationCategory.cafeteria:
        return 'Yemekhane';
      case CampusLocationCategory.transport:
        return 'Ulaşım';
      case CampusLocationCategory.administrative:
        return 'İdari';
      case CampusLocationCategory.social:
        return 'Sosyal';
    }
  }
}

class CampusLocationEntity {
  const CampusLocationEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.campus,
    required this.walkingTime,
    required this.addressText,
  });

  final String id;
  final String name;
  final String description;
  final CampusLocationCategory category;
  final String campus;
  final String walkingTime;
  final String addressText;
}