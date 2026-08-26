class HomeResourcesEntity {
  const HomeResourcesEntity({
    required this.quickActions,
    required this.academicStats,
  });

  final List<HomeQuickLinkEntity> quickActions;
  final List<HomeAcademicStatEntity> academicStats;
}

class HomeQuickLinkEntity {
  const HomeQuickLinkEntity({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.url,
  });

  final String id;
  final String title;
  final String iconKey;
  final String url;
}

class HomeAcademicStatEntity {
  const HomeAcademicStatEntity({
    required this.id,
    required this.value,
    required this.label,
    required this.iconKey,
    required this.colorHex,
    required this.url,
  });

  final String id;
  final String value;
  final String label;
  final String iconKey;
  final String colorHex;
  final String url;
}
