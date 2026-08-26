import 'package:meu_mobile/features/events/data/datasources/events_remote_data_source.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/events/domain/repositories/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  const EventsRepositoryImpl(this._remoteDataSource);

  final EventsRemoteDataSource _remoteDataSource;

  @override
  Future<List<CampusEventEntity>> getEvents() async {
    final models = await _remoteDataSource.fetchEvents();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CampusEventEntity?> getEventById(String id) async {
    final model = await _remoteDataSource.fetchEventById(id);

    return model?.toEntity();
  }
}
