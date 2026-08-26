enum AnnouncementCategory { all, academic, administrative, event }

extension AnnouncementCategoryX on AnnouncementCategory {
  String get label {
    switch (this) {
      case AnnouncementCategory.all:
        return 'Tümü';
      case AnnouncementCategory.academic:
        return 'Akademik';
      case AnnouncementCategory.administrative:
        return 'İdari';
      case AnnouncementCategory.event:
        return 'Etkinlik';
    }
  }
}

class AnnouncementListItemEntity {
  const AnnouncementListItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.timeAgo,
    required this.publishedAt,
  });

  final String id;
  final String title;
  final String description;
  final String content;
  final AnnouncementCategory category;
  final String timeAgo;
  final String publishedAt;
}
