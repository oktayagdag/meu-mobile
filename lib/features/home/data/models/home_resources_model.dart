import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';

class HomeResourcesModel {
  const HomeResourcesModel({
    required this.quickActions,
    required this.academicStats,
  });

  factory HomeResourcesModel.fromJson(Map<String, dynamic> json) {
    final rawQuickActions = json['quickActions'];
    final rawAcademicStats = json['academicStats'];

    return HomeResourcesModel(
      quickActions: rawQuickActions is List
          ? rawQuickActions
                .whereType<Map<String, dynamic>>()
                .map(HomeQuickLinkModel.fromJson)
                .toList()
          : const [],
      academicStats: rawAcademicStats is List
          ? rawAcademicStats
                .whereType<Map<String, dynamic>>()
                .map(HomeAcademicStatModel.fromJson)
                .toList()
          : const [],
    );
  }

  final List<HomeQuickLinkModel> quickActions;
  final List<HomeAcademicStatModel> academicStats;

  HomeResourcesEntity toEntity() {
    return HomeResourcesEntity(
      quickActions: quickActions.map((item) => item.toEntity()).toList(),
      academicStats: academicStats.map((item) => item.toEntity()).toList(),
    );
  }
}

class HomeQuickLinkModel {
  const HomeQuickLinkModel({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.url,
  });

  factory HomeQuickLinkModel.fromJson(Map<String, dynamic> json) {
    return HomeQuickLinkModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      iconKey: json['icon']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  final String id;
  final String title;
  final String iconKey;
  final String url;

  HomeQuickLinkEntity toEntity() {
    return HomeQuickLinkEntity(
      id: id,
      title: title,
      iconKey: iconKey,
      url: url,
    );
  }
}

class HomeAcademicStatModel {
  const HomeAcademicStatModel({
    required this.id,
    required this.value,
    required this.label,
    required this.iconKey,
    required this.colorHex,
    required this.url,
  });

  factory HomeAcademicStatModel.fromJson(Map<String, dynamic> json) {
    return HomeAcademicStatModel(
      id: json['id']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      iconKey: json['icon']?.toString() ?? '',
      colorHex: json['color']?.toString() ?? '#2563EB',
      url: json['url']?.toString() ?? '',
    );
  }

  final String id;
  final String value;
  final String label;
  final String iconKey;
  final String colorHex;
  final String url;

  HomeAcademicStatEntity toEntity() {
    return HomeAcademicStatEntity(
      id: id,
      value: value,
      label: label,
      iconKey: iconKey,
      colorHex: colorHex,
      url: url,
    );
  }
}
