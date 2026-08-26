import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';

abstract interface class CampusMapRepository {
  Future<List<CampusLocationEntity>> getLocations({
    CampusLocationCategory category = CampusLocationCategory.all,
  });

  Future<CampusLocationEntity?> getLocationById(String id);
}
