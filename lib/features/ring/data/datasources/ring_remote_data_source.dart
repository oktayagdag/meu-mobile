import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/ring/data/models/ring_route_model.dart';

abstract interface class RingRemoteDataSource {
  Future<List<RingRouteModel>> fetchRoutes();

  Future<RingRouteModel?> fetchNextRing();
}

class DioRingRemoteDataSource implements RingRemoteDataSource {
  const DioRingRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<RingRouteModel>> fetchRoutes() async {
    try {
      final response = await _dio.get(ApiEndpoints.ringRoutes);

      await _cache.writeJson(key: CacheKeys.ringRoutes, value: response.data);

      return _parseRouteList(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.ringRoutes);

      if (cachedData != null) {
        return _parseRouteList(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<RingRouteModel?> fetchNextRing() async {
    try {
      final response = await _dio.get(ApiEndpoints.nextRing);

      await _cache.writeJson(key: CacheKeys.nextRing, value: response.data);

      return _parseRouteDetail(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.nextRing);

      if (cachedData != null) {
        return _parseRouteDetail(cachedData);
      }

      rethrow;
    }
  }

  List<RingRouteModel> _parseRouteList(dynamic data) {
    final List<dynamic> rawList;

    if (data is List) {
      rawList = data;
    } else if (data is Map<String, dynamic> && data['data'] is List) {
      rawList = data['data'] as List<dynamic>;
    } else {
      rawList = const [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map(RingRouteModel.fromJson)
        .toList();
  }

  RingRouteModel? _parseRouteDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return RingRouteModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return RingRouteModel.fromJson(data);
    }

    return null;
  }
}
