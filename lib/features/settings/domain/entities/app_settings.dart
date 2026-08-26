import 'package:flutter/material.dart';

enum AppThemePreference {
  system,
  light,
  dark;

  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  String get storageValue => name;

  static AppThemePreference fromStorage(String? value) {
    return AppThemePreference.values.firstWhere(
      (item) => item.storageValue == value,
      orElse: () => AppThemePreference.system,
    );
  }
}

class AppSettings {
  const AppSettings({
    required this.themePreference,
    required this.generalNotifications,
    required this.announcementNotifications,
    required this.eventNotifications,
    required this.cafeteriaReminder,
    required this.cafeteriaReminderHour,
    required this.cafeteriaReminderMinute,
  });

  static const defaults = AppSettings(
    themePreference: AppThemePreference.system,
    generalNotifications: true,
    announcementNotifications: true,
    eventNotifications: true,
    cafeteriaReminder: false,
    cafeteriaReminderHour: 11,
    cafeteriaReminderMinute: 30,
  );

  final AppThemePreference themePreference;
  final bool generalNotifications;
  final bool announcementNotifications;
  final bool eventNotifications;
  final bool cafeteriaReminder;
  final int cafeteriaReminderHour;
  final int cafeteriaReminderMinute;

  TimeOfDay get cafeteriaReminderTime {
    return TimeOfDay(
      hour: cafeteriaReminderHour,
      minute: cafeteriaReminderMinute,
    );
  }

  AppSettings copyWith({
    AppThemePreference? themePreference,
    bool? generalNotifications,
    bool? announcementNotifications,
    bool? eventNotifications,
    bool? cafeteriaReminder,
    int? cafeteriaReminderHour,
    int? cafeteriaReminderMinute,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      generalNotifications:
          generalNotifications ?? this.generalNotifications,
      announcementNotifications:
          announcementNotifications ?? this.announcementNotifications,
      eventNotifications: eventNotifications ?? this.eventNotifications,
      cafeteriaReminder: cafeteriaReminder ?? this.cafeteriaReminder,
      cafeteriaReminderHour:
          cafeteriaReminderHour ?? this.cafeteriaReminderHour,
      cafeteriaReminderMinute:
          cafeteriaReminderMinute ?? this.cafeteriaReminderMinute,
    );
  }
}
