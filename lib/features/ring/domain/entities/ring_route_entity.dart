class RingRouteEntity {
  const RingRouteEntity({
    required this.from,
    required this.to,
    required this.time,
    required this.remainingMinute,
  });

  final String from;
  final String to;
  final String time;
  final int remainingMinute;
}