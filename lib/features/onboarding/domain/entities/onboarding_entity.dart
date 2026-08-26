enum OnboardingVisualType { campus, map, dailyLife, notifications }

class OnboardingEntity {
  const OnboardingEntity({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.visualType,
    required this.highlights,
  });

  final String eyebrow;
  final String title;
  final String description;
  final OnboardingVisualType visualType;
  final List<String> highlights;
}
