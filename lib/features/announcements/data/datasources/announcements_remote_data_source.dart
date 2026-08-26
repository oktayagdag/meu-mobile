import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/announcements/data/models/announcement_model.dart';

abstract interface class AnnouncementsRemoteDataSource {
  Future<List<AnnouncementModel>> fetchAnnouncements();

  Future<AnnouncementModel?> fetchAnnouncementById(String id);
}

class DioAnnouncementsRemoteDataSource
    implements AnnouncementsRemoteDataSource {
  const DioAnnouncementsRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final response = await _dio.get(ApiEndpoints.announcements);

      await _cache.writeJson(
        key: CacheKeys.announcements,
        value: response.data,
      );

      return _parseAnnouncementList(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.announcements);

      if (cachedData != null) {
        return _parseAnnouncementList(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<AnnouncementModel?> fetchAnnouncementById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.announcements}/$id');

      await _cache.writeJson(
        key: CacheKeys.announcementDetail(id),
        value: response.data,
      );

      return _parseAnnouncementDetail(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.announcementDetail(id));

      if (cachedData != null) {
        return _parseAnnouncementDetail(cachedData);
      }

      rethrow;
    }
  }

  List<AnnouncementModel> _parseAnnouncementList(dynamic data) {
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
        .map(AnnouncementModel.fromJson)
        .toList();
  }

  AnnouncementModel? _parseAnnouncementDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return AnnouncementModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return AnnouncementModel.fromJson(data);
    }

    return null;
  }
}
