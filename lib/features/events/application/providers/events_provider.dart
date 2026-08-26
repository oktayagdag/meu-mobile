import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/events/data/datasources/events_remote_data_source.dart';
import 'package:meu_mobile/features/events/data/repositories/events_repository_impl.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/events/domain/repositories/events_repository.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';

final eventsRemoteDataSourceProvider = Provider<EventsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(apiCacheServiceProvider);

  return DioEventsRemoteDataSource(dio, cache);
});

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final remoteDataSource = ref.watch(eventsRemoteDataSourceProvider);

  return EventsRepositoryImpl(remoteDataSource);
});

final eventsProvider = FutureProvider<List<CampusEventEntity>>((ref) async {
  final repository = ref.watch(eventsRepositoryProvider);

  return repository.getEvents();
});

final eventDetailProvider = FutureProvider.family<CampusEventEntity?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(eventsRepositoryProvider);

  return repository.getEventById(id);
});

final selectedEventCategoryProvider =
    NotifierProvider<SelectedEventCategoryNotifier, CampusEventCategory>(
      SelectedEventCategoryNotifier.new,
    );

class SelectedEventCategoryNotifier extends Notifier<CampusEventCategory> {
  @override
  CampusEventCategory build() {
    return CampusEventCategory.all;
  }

  void select(CampusEventCategory category) {
    state = category;
  }
}

final eventSearchQueryProvider =
    NotifierProvider<EventSearchQueryNotifier, String>(
      EventSearchQueryNotifier.new,
    );

class EventSearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }
}

final filteredEventsProvider = FutureProvider<List<CampusEventEntity>>((
  ref,
) async {
  final events = await ref.watch(eventsProvider.future);
  final selectedCategory = ref.watch(selectedEventCategoryProvider);
  final query = ref.watch(eventSearchQueryProvider).trim().toLowerCase();

  return events.where((event) {
    final matchesCategory =
        selectedCategory == CampusEventCategory.all ||
        event.category == selectedCategory;

    final matchesQuery =
        query.isEmpty ||
        event.title.toLowerCase().contains(query) ||
        event.description.toLowerCase().contains(query) ||
        event.content.toLowerCase().contains(query) ||
        event.location.toLowerCase().contains(query) ||
        event.organizer.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});
