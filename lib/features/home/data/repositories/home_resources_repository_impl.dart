import 'package:meu_mobile/features/home/data/datasources/home_resources_remote_data_source.dart';
import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';
import 'package:meu_mobile/features/home/domain/repositories/home_resources_repository.dart';

class HomeResourcesRepositoryImpl implements HomeResourcesRepository {
  const HomeResourcesRepositoryImpl(this._remoteDataSource);

  final HomeResourcesRemoteDataSource _remoteDataSource;

  @override
  Future<HomeResourcesEntity> getHomeResources() async {
    final model = await _remoteDataSource.fetchHomeResources();
    return model.toEntity();
  }
}
