import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';

class StudentClubModel {
  const StudentClubModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.category,
    required this.memberCount,
    required this.presidentName,
    required this.whatsappUrl,
    required this.instagramUrl,
  });

  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final StudentClubCategory category;
  final int memberCount;
  final String presidentName;
  final String whatsappUrl;
  final String instagramUrl;

  factory StudentClubModel.fromJson(Map<String, dynamic> json) {
    return StudentClubModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',

      // Yeni API formatı varsa shortDescription kullanır.
      // Eski test API formatında description kısa açıklamaydı.
      shortDescription:
          json['shortDescription']?.toString() ??
          json['short_description']?.toString() ??
          json['description']?.toString() ??
          '',

      // Mevcut test API'mizde uzun açıklama "content" alanındaydı.
      description:
          json['content']?.toString() ?? json['description']?.toString() ?? '',

      category: _categoryFromValue(json['category']?.toString()),

      memberCount:
          int.tryParse(json['memberCount']?.toString() ?? '') ??
          int.tryParse(json['member_count']?.toString() ?? '') ??
          0,

      presidentName:
          json['presidentName']?.toString() ??
          json['president_name']?.toString() ??
          '',

      whatsappUrl:
          json['whatsappUrl']?.toString() ??
          json['whatsapp_url']?.toString() ??
          '',

      instagramUrl:
          json['instagramUrl']?.toString() ??
          json['instagram_url']?.toString() ??
          '',
    );
  }

  StudentClubEntity toEntity() {
    return StudentClubEntity(
      id: id,
      name: name,
      shortDescription: shortDescription,
      description: description,
      category: category,
      memberCount: memberCount,
      presidentName: presidentName,
      whatsappUrl: whatsappUrl,
      instagramUrl: instagramUrl,
    );
  }

  static StudentClubCategory _categoryFromValue(String? value) {
    switch (_normalize(value)) {
      case 'technology':
      case 'teknoloji':
        return StudentClubCategory.technology;

      case 'culture':
      case 'cultural':
      case 'kultur':
      case 'art':
      case 'sanat':
        return StudentClubCategory.culture;

      case 'sport':
      case 'sports':
      case 'spor':
        return StudentClubCategory.sport;

      case 'social':
      case 'sosyal':
      case 'career':
      case 'kariyer':
        return StudentClubCategory.social;

      case 'science':
      case 'bilim':
        return StudentClubCategory.science;

      default:
        return StudentClubCategory.social;
    }
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
