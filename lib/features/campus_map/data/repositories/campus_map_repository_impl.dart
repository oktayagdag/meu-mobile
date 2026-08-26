import 'package:meu_mobile/features/campus_map/data/datasources/campus_map_remote_data_source.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';
import 'package:meu_mobile/features/campus_map/domain/repositories/campus_map_repository.dart';

class CampusMapRepositoryImpl implements CampusMapRepository {
  const CampusMapRepositoryImpl(this._remoteDataSource);

  final CampusMapRemoteDataSource _remoteDataSource;

  @override
  Future<List<CampusLocationEntity>> getLocations({
    CampusLocationCategory category = CampusLocationCategory.all,
  }) async {
    final models = await _remoteDataSource.fetchLocations(category: category);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CampusLocationEntity?> getLocationById(String id) async {
    final model = await _remoteDataSource.fetchLocationById(id);

    return model?.toEntity();
  }
}
