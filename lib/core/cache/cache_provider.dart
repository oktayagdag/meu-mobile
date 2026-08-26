import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';

final apiCacheServiceProvider = Provider<ApiCacheService>((ref) {
  final box = Hive.box<String>(ApiCacheService.boxName);

  return ApiCacheService(box);
});
