import '../../domain/entities/transit_dashboard_entity.dart';

class TransitDashboardModel extends TransitDashboardEntity {
  const TransitDashboardModel({
    required super.nearestStop,
    required super.nearbyStops,
    required super.upcomingVehicles,
  });

  factory TransitDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final nearestStopJson = data['nearestStop'] as Map<String, dynamic>?;

    final nearbyStopsJson = data['nearbyStops'] as List<dynamic>? ?? const [];

    final upcomingVehiclesJson =
        data['upcomingVehicles'] as List<dynamic>? ?? const [];

    return TransitDashboardModel(
      nearestStop: nearestStopJson == null
          ? null
          : TransitStopModel.fromJson(nearestStopJson),
      nearbyStops: nearbyStopsJson
          .whereType<Map<String, dynamic>>()
          .map(TransitStopModel.fromJson)
          .toList(),
      upcomingVehicles: upcomingVehiclesJson
          .whereType<Map<String, dynamic>>()
          .map(TransitUpcomingVehicleModel.fromJson)
          .toList(),
    );
  }
}

class TransitStopModel extends TransitStopEntity {
  const TransitStopModel({
    required super.id,
    required super.stopNo,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.lines,
    required super.arrivals,
    required super.distanceMeters,
    required super.walkingMinutes,
    required super.directionType,
    required super.directionLabel,
  });

  factory TransitStopModel.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? const [];

    final arrivalsJson = json['arrivals'] as List<dynamic>? ?? const [];

    return TransitStopModel(
      id: _stringValue(json['id'] ?? json['stopNo']),
      stopNo: _stringValue(json['stopNo']),
      name: _stringValue(json['name']),
      latitude: _doubleValue(json['latitude']),
      longitude: _doubleValue(json['longitude']),
      distanceMeters: _intValue(json['distanceMeters']),
      walkingMinutes: _intValue(json['walkingMinutes']),
      lines: linesJson
          .whereType<Map<String, dynamic>>()
          .map(TransitLineModel.fromJson)
          .toList(),
      arrivals: arrivalsJson
          .whereType<Map<String, dynamic>>()
          .map(TransitArrivalModel.fromJson)
          .toList(),
      directionType: json['directionType']?.toString().trim() ?? '',

      directionLabel:
          json['directionLabel']?.toString().trim() ?? 'Yön bilgisi yok',
    );
  }
}

class TransitLineModel extends TransitLineEntity {
  const TransitLineModel({
    required super.lineNo,
    required super.direction,
    required super.lineKey,
    required super.name,
  });

  factory TransitLineModel.fromJson(Map<String, dynamic> json) {
    return TransitLineModel(
      lineNo: _stringValue(json['lineNo']),
      direction: _stringValue(json['direction']),
      lineKey: _stringValue(json['lineKey']),
      name: _stringValue(json['name']),
    );
  }
}

class TransitArrivalModel extends TransitArrivalEntity {
  const TransitArrivalModel({
    required super.lineNo,
    required super.direction,
    required super.lineKey,
    required super.name,
    required super.minutes,
    required super.hasVehicle,
    required super.status,
    required super.hasNote,
  });

  factory TransitArrivalModel.fromJson(Map<String, dynamic> json) {
    return TransitArrivalModel(
      lineNo: _stringValue(json['lineNo']),
      direction: _stringValue(json['direction']),
      lineKey: _stringValue(json['lineKey']),
      name: _stringValue(json['name']),
      minutes: _nullableIntValue(json['minutes']),
      hasVehicle: _boolValue(json['hasVehicle']),
      status: _stringValue(json['status']),
      hasNote: _boolValue(json['hasNote']),
    );
  }
}

class TransitUpcomingVehicleModel extends TransitUpcomingVehicleEntity {
  const TransitUpcomingVehicleModel({
    required super.lineNo,
    required super.direction,
    required super.lineKey,
    required super.name,
    required super.minutes,
    required super.hasVehicle,
    required super.status,
    required super.hasNote,
    required super.stop,
  });

  factory TransitUpcomingVehicleModel.fromJson(Map<String, dynamic> json) {
    final stopJson =
        json['stop'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return TransitUpcomingVehicleModel(
      lineNo: _stringValue(json['lineNo']),
      direction: _stringValue(json['direction']),
      lineKey: _stringValue(json['lineKey']),
      name: _stringValue(json['name']),
      minutes: _nullableIntValue(json['minutes']),
      hasVehicle: _boolValue(json['hasVehicle']),
      status: _stringValue(json['status']),
      hasNote: _boolValue(json['hasNote']),
      stop: TransitVehicleStopModel.fromJson(stopJson),
    );
  }
}

class TransitVehicleStopModel extends TransitVehicleStopEntity {
  const TransitVehicleStopModel({
    required super.stopNo,
    required super.name,
    required super.distanceMeters,
    required super.walkingMinutes,
  });

  factory TransitVehicleStopModel.fromJson(Map<String, dynamic> json) {
    return TransitVehicleStopModel(
      stopNo: _stringValue(json['stopNo']),
      name: _stringValue(json['name']),
      distanceMeters: _intValue(json['distanceMeters']),
      walkingMinutes: _intValue(json['walkingMinutes']),
    );
  }
}

String _stringValue(dynamic value) {
  return value?.toString() ?? '';
}

int _intValue(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _nullableIntValue(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

double _doubleValue(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _boolValue(dynamic value) {
  if (value is bool) {
    return value;
  }

  return value?.toString().toLowerCase() == 'true';
}
