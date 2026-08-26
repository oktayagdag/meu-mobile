import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/campus_map/data/models/campus_location_model.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';

abstract interface class CampusMapRemoteDataSource {
  Future<List<CampusLocationModel>> fetchLocations({
    CampusLocationCategory category = CampusLocationCategory.all,
  });

  Future<CampusLocationModel?> fetchLocationById(String id);
}

class DioCampusMapRemoteDataSource implements CampusMapRemoteDataSource {
  const DioCampusMapRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<CampusLocationModel>> fetchLocations({
    CampusLocationCategory category = CampusLocationCategory.all,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.campusLocations,
        queryParameters: category == CampusLocationCategory.all
            ? null
            : {'category': category.name},
      );

      final locations = _parseLocationList(response.data);

      // Ana cache her zaman tüm kampüs listesini temsil etsin.
      // Kategori filtresiyle gelen daraltılmış listeyi bu ana cache'in üstüne yazmıyoruz.
      if (category == CampusLocationCategory.all) {
        await _cache.writeJson(
          key: CacheKeys.campusLocations,
          value: response.data,
        );
      }

      return locations;
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.campusLocations);

      if (cachedData != null) {
        final cachedLocations = _parseLocationList(cachedData);

        if (category == CampusLocationCategory.all) {
          return cachedLocations;
        }

        return cachedLocations
            .where((location) => location.category == category)
            .toList();
      }

      rethrow;
    }
  }

  @override
  Future<CampusLocationModel?> fetchLocationById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.campusLocations}/$id');

      await _cache.writeJson(
        key: CacheKeys.campusLocationDetail(id),
        value: response.data,
      );

      return _parseLocationDetail(response.data);
    } catch (_) {
      final cachedDetailData = _cache.readJsonData(
        CacheKeys.campusLocationDetail(id),
      );

      if (cachedDetailData != null) {
        return _parseLocationDetail(cachedDetailData);
      }

      final cachedListData = _cache.readJsonData(CacheKeys.campusLocations);

      if (cachedListData != null) {
        final cachedLocations = _parseLocationList(cachedListData);

        for (final location in cachedLocations) {
          if (location.id == id) {
            return location;
          }
        }
      }

      rethrow;
    }
  }

  List<CampusLocationModel> _parseLocationList(dynamic data) {
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
        .map(CampusLocationModel.fromJson)
        .toList();
  }

  CampusLocationModel? _parseLocationDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return CampusLocationModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return CampusLocationModel.fromJson(data);
    }

    return null;
  }
}
