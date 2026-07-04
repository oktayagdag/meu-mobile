import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_mock_provider.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/events/application/providers/events_mock_provider.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/food/application/providers/food_mock_provider.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_mock_provider.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';

final homeTodayFoodProvider = Provider<FoodEntity?>((ref) {
  final foods = ref.watch(weeklyFoodProvider);

  if (foods.isEmpty) {
    return null;
  }

  if (foods.length > 2) {
    return foods[2];
  }

  return foods.first;
});

final homeNextRingRouteProvider = Provider<RingRouteEntity?>((ref) {
  final routes = ref.watch(ringRoutesProvider);

  if (routes.isEmpty) {
    return null;
  }

  final sortedRoutes = [...routes]
    ..sort(
      (first, second) => first.remainingMinute.compareTo(
        second.remainingMinute,
      ),
    );

  return sortedRoutes.first;
});

final homeLatestAnnouncementProvider = Provider<AnnouncementListItemEntity?>((ref) {
  final announcements = ref.watch(announcementsProvider);

  if (announcements.isEmpty) {
    return null;
  }

  return announcements.first;
});

final homeUpcomingEventProvider = Provider<CampusEventEntity?>((ref) {
  final events = ref.watch(eventsProvider);

  if (events.isEmpty) {
    return null;
  }

  return events.first;
});