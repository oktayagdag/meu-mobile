import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_provider.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/events/application/providers/events_provider.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/food/application/providers/food_provider.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_provider.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

final homeTodayFoodProvider = FutureProvider<FoodEntity?>((ref) async {
  return ref.watch(todayFoodProvider.future);
});

final homeNextRingRouteProvider = FutureProvider<RingRouteEntity?>((ref) async {
  return ref.watch(nextRingApiProvider.future);
});

final homeLatestAnnouncementProvider =
    FutureProvider<AnnouncementListItemEntity?>((ref) async {
      final announcements = await ref.watch(announcementsProvider.future);

      if (announcements.isEmpty) {
        return null;
      }

      return announcements.first;
    });

final homeUpcomingEventProvider = FutureProvider<CampusEventEntity?>((
  ref,
) async {
  final events = await ref.watch(eventsProvider.future);

  if (events.isEmpty) {
    return null;
  }

  return events.first;
});
