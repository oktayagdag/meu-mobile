import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/clubs/data/models/student_club_model.dart';

abstract interface class ClubsRemoteDataSource {
  Future<List<StudentClubModel>> fetchClubs();

  Future<StudentClubModel?> fetchClubById(String id);
}

class DioClubsRemoteDataSource implements ClubsRemoteDataSource {
  const DioClubsRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<StudentClubModel>> fetchClubs() async {
    try {
      final response = await _dio.get(ApiEndpoints.clubs);

      await _cache.writeJson(key: CacheKeys.clubs, value: response.data);

      return _parseClubList(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.clubs);

      if (cachedData != null) {
        return _parseClubList(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<StudentClubModel?> fetchClubById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.clubs}/$id');

      await _cache.writeJson(
        key: CacheKeys.clubDetail(id),
        value: response.data,
      );

      return _parseClubDetail(response.data);
    } catch (_) {
      final cachedDetailData = _cache.readJsonData(CacheKeys.clubDetail(id));

      if (cachedDetailData != null) {
        return _parseClubDetail(cachedDetailData);
      }

      final cachedListData = _cache.readJsonData(CacheKeys.clubs);

      if (cachedListData != null) {
        final cachedClubs = _parseClubList(cachedListData);

        for (final club in cachedClubs) {
          if (club.id == id) {
            return club;
          }
        }
      }

      rethrow;
    }
  }

  List<StudentClubModel> _parseClubList(dynamic data) {
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
        .map(StudentClubModel.fromJson)
        .toList();
  }

  StudentClubModel? _parseClubDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return StudentClubModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return StudentClubModel.fromJson(data);
    }

    return null;
  }
}
