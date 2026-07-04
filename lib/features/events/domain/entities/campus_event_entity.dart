enum CampusEventCategory {
  all,
  conference,
  community,
  culture,
  sport,
}

extension CampusEventCategoryX on CampusEventCategory {
  String get label {
    switch (this) {
      case CampusEventCategory.all:
        return 'Tümü';
      case CampusEventCategory.conference:
        return 'Konferans';
      case CampusEventCategory.community:
        return 'Topluluk';
      case CampusEventCategory.culture:
        return 'Kültür';
      case CampusEventCategory.sport:
        return 'Spor';
    }
  }
}

class CampusEventEntity {
  const CampusEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
  });

  final String id;
  final String title;
  final String description;
  final String content;
  final CampusEventCategory category;
  final String date;
  final String time;
  final String location;
  final String organizer;
}