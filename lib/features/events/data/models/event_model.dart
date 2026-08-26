import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';

class EventModel {
  const EventModel({
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

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      category: _categoryFromValue(json['category']?.toString()),
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      organizer: json['organizer']?.toString() ?? '',
    );
  }

  CampusEventEntity toEntity() {
    return CampusEventEntity(
      id: id,
      title: title,
      description: description,
      content: content,
      category: category,
      date: date,
      time: time,
      location: location,
      organizer: organizer,
    );
  }

  static CampusEventCategory _categoryFromValue(String? value) {
    final normalizedValue = _normalize(value);

    for (final category in CampusEventCategory.values) {
      if (_normalize(category.name) == normalizedValue) {
        return category;
      }
    }

    final fallbackNames = _fallbackCategoryNames(normalizedValue);

    for (final fallbackName in fallbackNames) {
      for (final category in CampusEventCategory.values) {
        if (_normalize(category.name) == _normalize(fallbackName)) {
          return category;
        }
      }
    }

    return _defaultCategory();
  }

  static List<String> _fallbackCategoryNames(String value) {
    switch (value) {
      case 'academic':
      case 'akademik':
        return ['seminar', 'workshop', 'conference', 'education', 'other'];

      case 'culture':
      case 'cultural':
      case 'kultur':
      case 'kültür':
        return ['culture', 'art', 'social', 'other'];

      case 'sport':
      case 'sports':
      case 'spor':
        return ['sport', 'sports', 'social', 'other'];

      case 'social':
      case 'sosyal':
        return ['social', 'club', 'culture', 'other'];

      default:
        return ['other', 'social'];
    }
  }

  static CampusEventCategory _defaultCategory() {
    return CampusEventCategory.values.firstWhere(
      (category) => category.name != 'all',
      orElse: () => CampusEventCategory.values.first,
    );
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
