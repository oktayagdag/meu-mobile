import 'package:dio/dio.dart';

import '../models/transit_dashboard_model.dart';
import '../models/transit_line_tracking_model.dart';

abstract class TransitRemoteDataSource {
  Future<TransitDashboardModel> getDashboard({
    required double latitude,
    required double longitude,
  });

  Future<List<TransitRouteStopModel>> getLineStops({
    required String lineKey,
  });

  Future<List<TransitLiveVehicleModel>> getLineVehicles({
    required String lineKey,
  });
}

class TransitRemoteDataSourceImpl implements TransitRemoteDataSource {
  const TransitRemoteDataSourceImpl(
    this._dio,
  );

  final Dio _dio;

  @override
  Future<TransitDashboardModel> getDashboard({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/ring/dashboard',
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
      },
    );

    final data = response.data;

    if (data == null) {
      throw Exception(
        'Ulaşım servisi boş cevap döndürdü.',
      );
    }

    if (data['success'] != true) {
      throw Exception(
        data['message']?.toString() ?? 'Ulaşım bilgileri alınamadı.',
      );
    }

    return TransitDashboardModel.fromJson(
      data,
    );
  }

  @override
  Future<List<TransitRouteStopModel>> getLineStops({
    required String lineKey,
  }) async {
    final encodedLineKey = Uri.encodeComponent(
      lineKey,
    );

    final response = await _dio.get<Map<String, dynamic>>(
      '/ring/lines/$encodedLineKey/stops',
    );

    final responseData = response.data;

    if (responseData == null) {
      throw Exception(
        'Hat rota bilgisi alınamadı.',
      );
    }

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ?? 'Hat rota bilgisi alınamadı.',
      );
    }

    final list = responseData['data'] as List<dynamic>? ?? const [];

    final stops = <TransitRouteStopModel>[];

    for (var index = 0; index < list.length; index++) {
      final item = list[index];

      if (item is Map<String, dynamic>) {
        stops.add(
          TransitRouteStopModel.fromJson(
            item,
            fallbackOrder: index,
          ),
        );
      }
    }

    stops.sort(
      (first, second) => first.order.compareTo(
        second.order,
      ),
    );

    return stops;
  }

  @override
  Future<List<TransitLiveVehicleModel>> getLineVehicles({
    required String lineKey,
  }) async {
    final encodedLineKey = Uri.encodeComponent(
      lineKey,
    );

    final response = await _dio.get<Map<String, dynamic>>(
      '/ring/lines/$encodedLineKey/vehicles',
    );

    final responseData = response.data;

    if (responseData == null) {
      throw Exception(
        'Canlı araç bilgisi alınamadı.',
      );
    }

    if (responseData['success'] != true) {
      throw Exception(
        responseData['message']?.toString() ?? 'Canlı araç bilgisi alınamadı.',
      );
    }

    final list = responseData['data'] as List<dynamic>? ?? const [];

    final vehicles = <TransitLiveVehicleModel>[];

    for (var index = 0; index < list.length; index++) {
      final item = list[index];

      if (item is Map<String, dynamic>) {
        final vehicle = TransitLiveVehicleModel.fromJson(
          item,
          fallbackIndex: index,
        );

        if (vehicle.hasLocation) {
          vehicles.add(vehicle);
        }
      }
    }

    return vehicles;
  }
}
