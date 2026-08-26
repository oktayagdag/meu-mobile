import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/home/data/datasources/home_resources_remote_data_source.dart';
import 'package:meu_mobile/features/home/data/repositories/home_resources_repository_impl.dart';
import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';
import 'package:meu_mobile/features/home/domain/repositories/home_resources_repository.dart';

final homeResourcesRemoteDataSourceProvider =
    Provider<HomeResourcesRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      final cache = ref.watch(apiCacheServiceProvider);

      return DioHomeResourcesRemoteDataSource(dio, cache);
    });

final homeResourcesRepositoryProvider = Provider<HomeResourcesRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(homeResourcesRemoteDataSourceProvider);

  return HomeResourcesRepositoryImpl(remoteDataSource);
});

final homeResourcesProvider = FutureProvider<HomeResourcesEntity>((ref) async {
  final repository = ref.watch(homeResourcesRepositoryProvider);

  return repository.getHomeResources();
});
