import '../entities/transit_dashboard_entity.dart';
import '../entities/transit_line_tracking_entity.dart';

abstract class TransitRepository {
  Future<TransitDashboardEntity> getDashboard({
    required double latitude,
    required double longitude,
  });

  Future<List<TransitRouteStopEntity>> getLineStops({
    required String lineKey,
  });

  Future<List<TransitLiveVehicleEntity>> getLineVehicles({
    required String lineKey,
  });
}
