import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';

abstract interface class HomeResourcesRepository {
  Future<HomeResourcesEntity> getHomeResources();
}
