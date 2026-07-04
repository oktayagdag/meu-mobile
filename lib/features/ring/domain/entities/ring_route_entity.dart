class RingRouteEntity {
  const RingRouteEntity({
    required this.from,
    required this.to,
    required this.remainingMinute,
    required this.frequencyText,
    this.isFavorite = false,
  });

  final String from;
  final String to;
  final int remainingMinute;
  final String frequencyText;
  final bool isFavorite;

  String get title => '$from → $to';
}