import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

abstract interface class RingRepository {
  Future<List<RingRouteEntity>> getRoutes();

  Future<RingRouteEntity?> getNextRing();
}
