import 'package:meu_mobile/features/settings/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const _themeKey = 'settings.theme';
  static const _generalNotificationsKey =
      'settings.notifications.general';
  static const _announcementNotificationsKey =
      'settings.notifications.announcements';
  static const _eventNotificationsKey =
      'settings.notifications.events';
  static const _cafeteriaReminderKey =
      'settings.notifications.cafeteriaReminder';
  static const _cafeteriaReminderHourKey =
      'settings.notifications.cafeteriaReminderHour';
  static const _cafeteriaReminderMinuteKey =
      'settings.notifications.cafeteriaReminderMinute';

  Future<AppSettings> load() async {
    final preferences = await SharedPreferences.getInstance();

    return AppSettings(
      themePreference: AppThemePreference.fromStorage(
        preferences.getString(_themeKey),
      ),
      generalNotifications:
          preferences.getBool(_generalNotificationsKey) ??
              AppSettings.defaults.generalNotifications,
      announcementNotifications:
          preferences.getBool(_announcementNotificationsKey) ??
              AppSettings.defaults.announcementNotifications,
      eventNotifications:
          preferences.getBool(_eventNotificationsKey) ??
              AppSettings.defaults.eventNotifications,
      cafeteriaReminder:
          preferences.getBool(_cafeteriaReminderKey) ??
              AppSettings.defaults.cafeteriaReminder,
      cafeteriaReminderHour:
          preferences.getInt(_cafeteriaReminderHourKey) ??
              AppSettings.defaults.cafeteriaReminderHour,
      cafeteriaReminderMinute:
          preferences.getInt(_cafeteriaReminderMinuteKey) ??
              AppSettings.defaults.cafeteriaReminderMinute,
    );
  }

  Future<void> save(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await Future.wait([
      preferences.setString(
        _themeKey,
        settings.themePreference.storageValue,
      ),
      preferences.setBool(
        _generalNotificationsKey,
        settings.generalNotifications,
      ),
      preferences.setBool(
        _announcementNotificationsKey,
        settings.announcementNotifications,
      ),
      preferences.setBool(
        _eventNotificationsKey,
        settings.eventNotifications,
      ),
      preferences.setBool(
        _cafeteriaReminderKey,
        settings.cafeteriaReminder,
      ),
      preferences.setInt(
        _cafeteriaReminderHourKey,
        settings.cafeteriaReminderHour,
      ),
      preferences.setInt(
        _cafeteriaReminderMinuteKey,
        settings.cafeteriaReminderMinute,
      ),
    ]);
  }
}
