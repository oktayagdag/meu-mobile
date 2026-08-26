import 'package:meu_mobile/features/ring/data/datasources/ring_remote_data_source.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/features/ring/domain/repositories/ring_repository.dart';

class RingRepositoryImpl implements RingRepository {
  const RingRepositoryImpl(this._remoteDataSource);

  final RingRemoteDataSource _remoteDataSource;

  @override
  Future<List<RingRouteEntity>> getRoutes() async {
    final models = await _remoteDataSource.fetchRoutes();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<RingRouteEntity?> getNextRing() async {
    final model = await _remoteDataSource.fetchNextRing();

    return model?.toEntity();
  }
}
