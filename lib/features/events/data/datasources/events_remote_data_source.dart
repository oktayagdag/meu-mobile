import 'package:dio/dio.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/core/network/api_endpoints.dart';
import 'package:meu_mobile/features/events/data/models/event_model.dart';

abstract interface class EventsRemoteDataSource {
  Future<List<EventModel>> fetchEvents();

  Future<EventModel?> fetchEventById(String id);
}

class DioEventsRemoteDataSource implements EventsRemoteDataSource {
  const DioEventsRemoteDataSource(this._dio, this._cache);

  final Dio _dio;
  final ApiCacheService _cache;

  @override
  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _dio.get(ApiEndpoints.events);

      await _cache.writeJson(key: CacheKeys.events, value: response.data);

      return _parseEventList(response.data);
    } catch (_) {
      final cachedData = _cache.readJsonData(CacheKeys.events);

      if (cachedData != null) {
        return _parseEventList(cachedData);
      }

      rethrow;
    }
  }

  @override
  Future<EventModel?> fetchEventById(String id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.events}/$id');

      await _cache.writeJson(
        key: CacheKeys.eventDetail(id),
        value: response.data,
      );

      return _parseEventDetail(response.data);
    } catch (_) {
      final cachedDetailData = _cache.readJsonData(CacheKeys.eventDetail(id));

      if (cachedDetailData != null) {
        return _parseEventDetail(cachedDetailData);
      }

      final cachedListData = _cache.readJsonData(CacheKeys.events);

      if (cachedListData != null) {
        final cachedEvents = _parseEventList(cachedListData);

        for (final event in cachedEvents) {
          if (event.id == id) {
            return event;
          }
        }
      }

      rethrow;
    }
  }

  List<EventModel> _parseEventList(dynamic data) {
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
        .map(EventModel.fromJson)
        .toList();
  }

  EventModel? _parseEventDetail(dynamic data) {
    if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
      return EventModel.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic>) {
      return EventModel.fromJson(data);
    }

    return null;
  }
}
