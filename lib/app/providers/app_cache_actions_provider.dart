import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';

import 'package:meu_mobile/features/announcements/application/providers/announcements_provider.dart';
import 'package:meu_mobile/features/campus_map/application/providers/campus_map_provider.dart';
import 'package:meu_mobile/features/clubs/application/providers/clubs_provider.dart';
import 'package:meu_mobile/features/events/application/providers/events_provider.dart';
import 'package:meu_mobile/features/food/application/providers/food_provider.dart';
import 'package:meu_mobile/features/home/application/providers/home_dashboard_provider.dart';
import 'package:meu_mobile/features/home/application/providers/home_resources_provider.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_provider.dart';

final appCacheActionsProvider = Provider<AppCacheActions>((ref) {
  final cache = ref.watch(apiCacheServiceProvider);

  return AppCacheActions(ref: ref, cache: cache);
});

class AppCacheActions {
  const AppCacheActions({required this.ref, required this.cache});

  final Ref ref;
  final ApiCacheService cache;

  Future<void> clearApiCache() async {
    await cache.clearAll();

    _invalidateAnnouncements();
    _invalidateFoods();
    _invalidateRing();
    _invalidateEvents();
    _invalidateClubs();
    _invalidateCampusMap();
    _invalidateHome();
  }

  void _invalidateAnnouncements() {
    ref.invalidate(announcementsProvider);
    ref.invalidate(filteredAnnouncementsProvider);
  }

  void _invalidateFoods() {
    ref.invalidate(weeklyFoodProvider);
    ref.invalidate(todayFoodProvider);
  }

  void _invalidateRing() {
    ref.invalidate(ringRoutesApiProvider);
    ref.invalidate(nextRingApiProvider);
    ref.invalidate(visibleRingRoutesProvider);
  }

  void _invalidateEvents() {
    ref.invalidate(eventsProvider);
    ref.invalidate(filteredEventsProvider);
  }

  void _invalidateClubs() {
    ref.invalidate(clubsProvider);
    ref.invalidate(filteredClubsProvider);
  }

  void _invalidateCampusMap() {
    ref.invalidate(campusLocationsProvider);
    ref.invalidate(visibleCampusLocationsProvider);
    ref.invalidate(selectedCampusLocationProvider);
  }

  void _invalidateHome() {
    ref.invalidate(homeTodayFoodProvider);
    ref.invalidate(homeNextRingRouteProvider);
    ref.invalidate(homeLatestAnnouncementProvider);
    ref.invalidate(homeUpcomingEventProvider);
    ref.invalidate(homeResourcesProvider);
  }
}
