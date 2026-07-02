class AnnouncementEntity {
  const AnnouncementEntity({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
  });

  final String title;
  final String description;
  final String category;
  final String date;
}