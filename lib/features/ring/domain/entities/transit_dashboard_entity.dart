class TransitDashboardEntity {
  const TransitDashboardEntity({
    required this.nearestStop,
    required this.nearbyStops,
    required this.upcomingVehicles,
  });

  final TransitStopEntity? nearestStop;
  final List<TransitStopEntity> nearbyStops;
  final List<TransitUpcomingVehicleEntity> upcomingVehicles;
}

class TransitStopEntity {
  const TransitStopEntity({
    required this.id,
    required this.stopNo,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.lines,
    required this.arrivals,
    required this.distanceMeters,
    required this.walkingMinutes,
    required this.directionType,
    required this.directionLabel,
  });

  final String id;
  final String stopNo;
  final String name;

  final double latitude;
  final double longitude;

  final List<TransitLineEntity> lines;
  final List<TransitArrivalEntity> arrivals;

  final int distanceMeters;
  final int walkingMinutes;

  final String directionType;
  final String directionLabel;
}

class TransitLineEntity {
  const TransitLineEntity({
    required this.lineNo,
    required this.direction,
    required this.lineKey,
    required this.name,
  });

  final String lineNo;
  final String direction;
  final String lineKey;
  final String name;
}

class TransitArrivalEntity {
  const TransitArrivalEntity({
    required this.lineNo,
    required this.direction,
    required this.lineKey,
    required this.name,
    required this.minutes,
    required this.hasVehicle,
    required this.status,
    required this.hasNote,
  });

  final String lineNo;
  final String direction;
  final String lineKey;
  final String name;

  final int? minutes;

  final bool hasVehicle;
  final String status;
  final bool hasNote;

  bool get isArriving => status == 'arriving';

  bool get isLive => status == 'live';

  bool get hasNoVehicle => status == 'no_vehicle';

  String get arrivalText {
    if (!hasVehicle) {
      return 'Aktif araç yok';
    }

    if (isArriving || minutes == 0) {
      return 'Yaklaşıyor';
    }

    if (minutes == null) {
      return 'Canlı';
    }

    return '$minutes dk';
  }
}

class TransitUpcomingVehicleEntity {
  const TransitUpcomingVehicleEntity({
    required this.lineNo,
    required this.direction,
    required this.lineKey,
    required this.name,
    required this.minutes,
    required this.hasVehicle,
    required this.status,
    required this.hasNote,
    required this.stop,
  });

  final String lineNo;
  final String direction;
  final String lineKey;
  final String name;

  final int? minutes;

  final bool hasVehicle;
  final String status;
  final bool hasNote;

  final TransitVehicleStopEntity stop;

  bool get isArriving => status == 'arriving';

  String get arrivalText {
    if (isArriving || minutes == 0) {
      return 'Yaklaşıyor';
    }

    if (minutes == null) {
      return 'Canlı';
    }

    return '$minutes dk';
  }
}

class TransitVehicleStopEntity {
  const TransitVehicleStopEntity({
    required this.stopNo,
    required this.name,
    required this.distanceMeters,
    required this.walkingMinutes,
  });

  final String stopNo;
  final String name;
  final int distanceMeters;
  final int walkingMinutes;
}
