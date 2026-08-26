import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/food/data/models/food_model.dart';

abstract interface class FoodRemoteDataSource {
  Future<List<FoodModel>> fetchWeeklyFoods();

  Future<FoodModel?> fetchTodayFood();
}

class DioFoodRemoteDataSource implements FoodRemoteDataSource {
  const DioFoodRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<FoodModel>> fetchWeeklyFoods() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.weeklyFoods,
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        await _cache.writeJson(key: CacheKeys.weeklyFoods, value: responseData);

        return _parseFoodList(responseData);
      }

      throw Exception('Haftalık yemek menüsü alınamadı.');
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.weeklyFoods);

      if (cachedData != null) {
        return _parseFoodList(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<FoodModel?> fetchTodayFood() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.todayFood,
      );

      final responseData = response.data;

      if (responseData != null && responseData['success'] == true) {
        await _cache.writeJson(key: CacheKeys.todayFood, value: responseData);

        return _parseFoodDetail(responseData);
      }

      return null;
    } on DioException catch (error) {
      // Hafta sonu veya menü bulunmayan günlerde backend 404 dönebilir.
      if (error.response?.statusCode == 404) {
        return null;
      }

      final cachedData = _cache.readJsonData(CacheKeys.todayFood);

      if (cachedData != null) {
        return _parseFoodDetail(cachedData);
      }

      rethrow;
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.todayFood);

      if (cachedData != null) {
        return _parseFoodDetail(cachedData);
      }

      rethrow;
    }
  }

  List<FoodModel> _parseFoodList(dynamic data) {
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
        .map(FoodModel.fromJson)
        .toList();
  }

  FoodModel? _parseFoodDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return FoodModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return FoodModel.fromJson(data);
    }

    return null;
  }
}
