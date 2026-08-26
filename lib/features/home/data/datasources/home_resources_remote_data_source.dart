import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/home/data/models/home_resources_model.dart';

abstract interface class HomeResourcesRemoteDataSource {
  Future<HomeResourcesModel> fetchHomeResources();
}

class DioHomeResourcesRemoteDataSource
    implements HomeResourcesRemoteDataSource {
  const DioHomeResourcesRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<HomeResourcesModel> fetchHomeResources() async {
    try {
      final response = await _dio.get(ApiEndpoints.homeResources);

      await _cache.writeJson(
        key: CacheKeys.homeResources,
        value: response.data,
      );

      return _parse(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.homeResources);

      if (cachedData != null) {
        return _parse(cachedData);
      }

      rethrow;
    }
  }

  HomeResourcesModel _parse(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return HomeResourcesModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return HomeResourcesModel.fromJson(data);
    }

    return const HomeResourcesModel(quickActions: [], academicStats: []);
  }
}
