import '../../domain/entities/transit_dashboard_entity.dart';
import '../../domain/entities/transit_line_tracking_entity.dart';
import '../../domain/repositories/transit_repository.dart';
import '../datasources/transit_remote_data_source.dart';

class TransitRepositoryImpl implements TransitRepository {
  const TransitRepositoryImpl(
    this._remoteDataSource,
  );

  final TransitRemoteDataSource _remoteDataSource;

  @override
  Future<TransitDashboardEntity> getDashboard({
    required double latitude,
    required double longitude,
  }) {
    return _remoteDataSource.getDashboard(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<List<TransitRouteStopEntity>> getLineStops({
    required String lineKey,
  }) {
    return _remoteDataSource.getLineStops(
      lineKey: lineKey,
    );
  }

  @override
  Future<List<TransitLiveVehicleEntity>> getLineVehicles({
    required String lineKey,
  }) {
    return _remoteDataSource.getLineVehicles(
      lineKey: lineKey,
    );
  }
}
