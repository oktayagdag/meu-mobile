final class CacheKeys {
  const CacheKeys._();

  static const String announcements = 'announcements';
  static String announcementDetail(String id) => 'announcement_detail_$id';

  static const String events = 'events';
  static String eventDetail(String id) => 'event_detail_$id';

  static const String weeklyFoods = 'weekly_foods';
  static const String todayFood = 'today_food';

  static const String ringRoutes = 'ring_routes';
  static const String nextRing = 'next_ring';

  static const String clubs = 'clubs';
  static String clubDetail(String id) => 'club_detail_$id';

  static const String campusLocations = 'campus_locations';
  static String campusLocationDetail(String id) => 'campus_location_detail_$id';
  static const String homeResources = 'home_resources';
}
