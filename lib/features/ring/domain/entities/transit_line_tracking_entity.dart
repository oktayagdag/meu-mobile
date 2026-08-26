class TransitRouteStopEntity {
  const TransitRouteStopEntity({
    required this.stopNo,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  final String stopNo;
  final String name;

  final double? latitude;
  final double? longitude;

  final int order;

  bool get hasLocation => latitude != null && longitude != null;
}

class TransitLiveVehicleEntity {
  const TransitLiveVehicleEntity({
    required this.id,
    required this.plate,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String plate;

  final double? latitude;
  final double? longitude;

  bool get hasLocation => latitude != null && longitude != null;
}
