import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/notifications/local_notification_service.dart';
import 'package:meu_mobile/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:meu_mobile/features/settings/domain/entities/app_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

final settingsLocalDataSourceProvider =
    Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSource();
});

final localNotificationServiceProvider =
    Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

final appSettingsProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

final packageInfoProvider =
    FutureProvider<PackageInfo>((ref) {
  return PackageInfo.fromPlatform();
});

class SettingsController extends AsyncNotifier<AppSettings> {
  SettingsLocalDataSource get _localDataSource {
    return ref.read(settingsLocalDataSourceProvider);
  }

  LocalNotificationService get _notificationService {
    return ref.read(localNotificationServiceProvider);
  }

  @override
  Future<AppSettings> build() {
    return _localDataSource.load();
  }

  Future<void> setTheme(
    AppThemePreference preference,
  ) async {
    final current = state.requireValue;
    final next = current.copyWith(
      themePreference: preference,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> setGeneralNotifications(
    bool enabled,
  ) async {
    final current = state.requireValue;

    if (!enabled && current.cafeteriaReminder) {
      await _notificationService.cancelCafeteriaReminder();
    }

    if (enabled && current.cafeteriaReminder) {
      await _notificationService.scheduleCafeteriaReminder(
        hour: current.cafeteriaReminderHour,
        minute: current.cafeteriaReminderMinute,
      );
    }

    final next = current.copyWith(
      generalNotifications: enabled,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> setAnnouncementNotifications(
    bool enabled,
  ) async {
    final current = state.requireValue;
    final next = current.copyWith(
      announcementNotifications: enabled,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> setEventNotifications(
    bool enabled,
  ) async {
    final current = state.requireValue;
    final next = current.copyWith(
      eventNotifications: enabled,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> setCafeteriaReminder(
    bool enabled,
  ) async {
    final current = state.requireValue;

    if (enabled) {
      await _notificationService.scheduleCafeteriaReminder(
        hour: current.cafeteriaReminderHour,
        minute: current.cafeteriaReminderMinute,
      );
    } else {
      await _notificationService.cancelCafeteriaReminder();
    }

    final next = current.copyWith(
      cafeteriaReminder: enabled,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> setCafeteriaReminderTime({
    required int hour,
    required int minute,
  }) async {
    final current = state.requireValue;

    if (current.generalNotifications &&
        current.cafeteriaReminder) {
      await _notificationService.scheduleCafeteriaReminder(
        hour: hour,
        minute: minute,
      );
    }

    final next = current.copyWith(
      cafeteriaReminderHour: hour,
      cafeteriaReminderMinute: minute,
    );

    await _commit(
      previous: current,
      next: next,
    );
  }

  Future<void> _commit({
    required AppSettings previous,
    required AppSettings next,
  }) async {
    state = AsyncData(next);

    try {
      await _localDataSource.save(next);
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      Error.throwWithStackTrace(
        error,
        stackTrace,
      );
    }
  }
}
