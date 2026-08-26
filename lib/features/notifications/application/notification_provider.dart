import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/notification_model.dart';
import '../domain/notification_type.dart';

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationModel>>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    return _mockNotifications;
  }

  // -----------------------
  // GETTERS
  // -----------------------

  int get unreadCount => state.where((e) => !e.isRead).length;

  bool get hasUnread => unreadCount > 0;

  bool get isEmpty => state.isEmpty;

  // -----------------------
  // ACTIONS
  // -----------------------

  void markAsRead(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: true)
        else
          notification,
    ];
  }

  void markAsUnread(String id) {
    state = [
      for (final notification in state)
        if (notification.id == id)
          notification.copyWith(isRead: false)
        else
          notification,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notification in state) notification.copyWith(isRead: true),
    ];
  }

  void delete(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  void clear() {
    state = [];
  }

  void add(NotificationModel notification) {
    state = [notification, ...state];
  }

  void addAll(List<NotificationModel> notifications) {
    state = [...notifications, ...state];
  }
}

///
/// MOCK DATA
///
/// Firebase gelince tamamen silinecek.
///

final List<NotificationModel> _mockNotifications = [
  NotificationModel(
    id: '1',
    title: 'Yeni Duyuru Yayınlandı',
    body: '2026-2027 Güz Dönemi akademik takvimi yayınlandı.',
    type: NotificationType.announcement,
    createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
  ),

  NotificationModel(
    id: '2',
    title: 'Kariyer Günleri Başlıyor',
    body: 'Mersin Üniversitesi Kariyer Günleri yarın saat 10:00\'da başlıyor.',
    type: NotificationType.event,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),

  NotificationModel(
    id: '3',
    title: 'Bugünün Yemek Menüsü',
    body: 'Bugünkü yemek listesi uygulamaya eklendi.',
    type: NotificationType.cafeteria,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    isRead: true,
  ),

  NotificationModel(
    id: '4',
    title: 'Yeni Topluluk Etkinliği',
    body: 'IEEE Öğrenci Topluluğu yeni etkinlik oluşturdu.',
    type: NotificationType.community,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),

  NotificationModel(
    id: '5',
    title: 'Ring Saatleri Güncellendi',
    body: 'Yeni ulaşım saatleri yayınlandı.',
    type: NotificationType.transportation,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    isRead: true,
  ),

  NotificationModel(
    id: '6',
    title: 'MEU Mobile Güncellendi',
    body: 'Yeni sürümde performans iyileştirmeleri yapıldı.',
    type: NotificationType.system,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
    isRead: true,
  ),
];
