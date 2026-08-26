import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class ApiCacheService {
  const ApiCacheService(this._box);

  static const String boxName = 'api_cache_box';

  final Box<String> _box;

  Future<void> writeJson({required String key, required Object? value}) async {
    final payload = {
      'savedAt': DateTime.now().toIso8601String(),
      'data': value,
    };

    await _box.put(key, jsonEncode(payload));
  }

  dynamic readJsonData(String key) {
    final rawValue = _box.get(key);

    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is Map<String, dynamic>) {
        return decoded['data'];
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  DateTime? readSavedAt(String key) {
    final rawValue = _box.get(key);

    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final savedAt = decoded['savedAt']?.toString();

      if (savedAt == null || savedAt.trim().isEmpty) {
        return null;
      }

      return DateTime.tryParse(savedAt);
    } catch (_) {
      return null;
    }
  }

  bool has(String key) {
    return _box.containsKey(key);
  }

  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
