import 'package:meu_mobile/core/config/app_environment.dart';

final class ApiEndpoints {
  const ApiEndpoints._();

  static String get baseUrl => AppEnvironment.apiBaseUrl;

  static const String announcements = 'announcements';
  static const String events = 'events';

  static const String weeklyFoods = 'foods/weekly';
  static const String todayFood = 'foods/today';

  static const String ringRoutes = 'ring/routes';
  static const String nextRing = 'ring/next';

  static const String clubs = 'clubs';

  static const String campusLocations = 'campus/locations';
  static const String homeResources = 'home/resources';
}
