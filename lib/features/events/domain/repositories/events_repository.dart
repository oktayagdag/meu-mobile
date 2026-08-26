import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';

abstract interface class EventsRepository {
  Future<List<CampusEventEntity>> getEvents();

  Future<CampusEventEntity?> getEventById(String id);
}
