enum StudentClubCategory {
  all,
  technology,
  culture,
  sport,
  social,
  science,
}

extension StudentClubCategoryX on StudentClubCategory {
  String get label {
    switch (this) {
      case StudentClubCategory.all:
        return 'Tümü';
      case StudentClubCategory.technology:
        return 'Teknoloji';
      case StudentClubCategory.culture:
        return 'Kültür';
      case StudentClubCategory.sport:
        return 'Spor';
      case StudentClubCategory.social:
        return 'Sosyal';
      case StudentClubCategory.science:
        return 'Bilim';
    }
  }
}

class StudentClubEntity {
  const StudentClubEntity({
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
}