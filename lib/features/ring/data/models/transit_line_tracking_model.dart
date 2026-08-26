import '../../domain/entities/transit_line_tracking_entity.dart';

class TransitRouteStopModel extends TransitRouteStopEntity {
  const TransitRouteStopModel({
    required super.stopNo,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.order,
  });

  factory TransitRouteStopModel.fromJson(
    Map<String, dynamic> json, {
    required int fallbackOrder,
  }) {
    return TransitRouteStopModel(
      stopNo: _stringValue(
        json['stopNo'] ?? json['durakNo'] ?? json['id'],
      ),
      name: _stringValue(
        json['name'] ?? json['stopName'] ?? json['durakAdi'],
      ),
      latitude: _nullableDoubleValue(
        json['latitude'] ?? json['lat'] ?? json['enlem'],
      ),
      longitude: _nullableDoubleValue(
        json['longitude'] ?? json['lng'] ?? json['lon'] ?? json['boylam'],
      ),
      order: _nullableIntValue(
            json['order'] ?? json['sequence'] ?? json['index'],
          ) ??
          fallbackOrder,
    );
  }
}

class TransitLiveVehicleModel extends TransitLiveVehicleEntity {
  const TransitLiveVehicleModel({
    required super.id,
    required super.plate,
    required super.latitude,
    required super.longitude,
  });

  factory TransitLiveVehicleModel.fromJson(
    Map<String, dynamic> json, {
    required int fallbackIndex,
  }) {
    final id = _stringValue(
      json['id'] ?? json['vehicleId'] ?? json['vehicleNo'] ?? json['aracId'],
    );

    return TransitLiveVehicleModel(
      id: id.isEmpty ? 'vehicle-$fallbackIndex' : id,
      plate: _stringValue(
        json['plate'] ?? json['plaka'] ?? json['vehiclePlate'],
      ),
      latitude: _nullableDoubleValue(
        json['latitude'] ?? json['lat'] ?? json['enlem'],
      ),
      longitude: _nullableDoubleValue(
        json['longitude'] ?? json['lng'] ?? json['lon'] ?? json['boylam'],
      ),
    );
  }
}

String _stringValue(dynamic value) {
  return value?.toString().trim() ?? '';
}

int? _nullableIntValue(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
    value.toString(),
  );
}

double? _nullableDoubleValue(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  final normalized = value.toString().trim().replaceAll(',', '.');

  return double.tryParse(normalized);
}
