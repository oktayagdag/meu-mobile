import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';

class AnnouncementModel {
  const AnnouncementModel({
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

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      category: _categoryFromValue(json['category']?.toString()),
      timeAgo:
          json['timeAgo']?.toString() ?? json['time_ago']?.toString() ?? '',
      publishedAt:
          json['publishedAt']?.toString() ??
          json['published_at']?.toString() ??
          '',
    );
  }

  AnnouncementListItemEntity toEntity() {
    return AnnouncementListItemEntity(
      id: id,
      title: title,
      description: description,
      content: content,
      category: category,
      timeAgo: timeAgo,
      publishedAt: publishedAt,
    );
  }

  static AnnouncementCategory _categoryFromValue(String? value) {
    switch (value?.toLowerCase()) {
      case 'academic':
      case 'akademik':
        return AnnouncementCategory.academic;
      case 'administrative':
      case 'idari':
      case 'i̇dari':
        return AnnouncementCategory.administrative;
      case 'event':
      case 'etkinlik':
        return AnnouncementCategory.event;
      default:
        return AnnouncementCategory.academic;
    }
  }
}
