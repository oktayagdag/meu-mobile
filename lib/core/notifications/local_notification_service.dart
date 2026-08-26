import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationPermissionDeniedException implements Exception {
  const NotificationPermissionDeniedException();

  @override
  String toString() => 'Bildirim izni verilmedi.';
}

class LocalNotificationService {
  static const int _cafeteriaReminderId = 4101;

  static const String _cafeteriaChannelId =
      'cafeteria_reminders';
  static const String _cafeteriaChannelName =
      'Yemekhane Hatırlatıcıları';
  static const String _cafeteriaChannelDescription =
      'Günlük yemekhane menüsü hatırlatmaları.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Europe/Istanbul'),
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
    );

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await initialize();

    final androidPermission = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        true;

    final iosPermission = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
        true;

    return androidPermission && iosPermission;
  }

  Future<void> scheduleCafeteriaReminder({
    required int hour,
    required int minute,
  }) async {
    await initialize();

    final permissionGranted = await requestPermission();

    if (!permissionGranted) {
      throw const NotificationPermissionDeniedException();
    }

    await cancelCafeteriaReminder();

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
    }

    await _plugin.zonedSchedule(
      id: _cafeteriaReminderId,
      title: 'Bugünün menüsüne göz at',
      body: 'Yemekhane menüsü MEUMOBİL’de hazır.',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _cafeteriaChannelId,
          _cafeteriaChannelName,
          channelDescription: _cafeteriaChannelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '/food',
    );
  }

  Future<void> cancelCafeteriaReminder() async {
    await initialize();

    await _plugin.cancel(
      id: _cafeteriaReminderId,
    );
  }
}
