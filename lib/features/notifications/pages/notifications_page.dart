import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/notification_provider.dart';
import '../domain/notification_model.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_empty.dart';
import '../widgets/notification_section.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    final notifier = ref.read(notificationsProvider.notifier);

    if (notifications.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Bildirimler"),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        body: const NotificationEmpty(),
      );
    }

    final today = _todayNotifications(notifications);

    final yesterday = _yesterdayNotifications(notifications);

    final thisWeek = _thisWeekNotifications(notifications);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirimler"),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: "Tümünü okundu yap",
            onPressed: notifier.markAllAsRead,
            icon: const Icon(Icons.done_all_rounded),
          ),
        ],
      ),

      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: .15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1743A).withValues(alpha: .10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFFF1743A),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notifier.unreadCount} okunmamış bildirim",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Yeni duyuru ve etkinlikleri kaçırma.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NotificationSection(
              title: "Bugün",
              children: today
                  .map(
                    (notification) => Dismissible(
                      key: ValueKey(notification.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),

                      onDismissed: (_) {
                        notifier.delete(notification.id);
                      },

                      child: NotificationCard(
                        notification: notification,
                        onTap: () {
                          notifier.markAsRead(notification.id);

                          if (notification.type.isNavigable) {
                            // TODO
                            // context.push(notification.type.route!);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),

            NotificationSection(
              title: "Dün",
              children: yesterday
                  .map(
                    (notification) => Dismissible(
                      key: ValueKey(notification.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),

                      onDismissed: (_) {
                        notifier.delete(notification.id);
                      },

                      child: NotificationCard(
                        notification: notification,
                        onTap: () {
                          notifier.markAsRead(notification.id);

                          if (notification.type.isNavigable) {
                            // TODO
                            // context.push(notification.type.route!);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),

            NotificationSection(
              title: "Bu Hafta",
              children: thisWeek
                  .map(
                    (notification) => Dismissible(
                      key: ValueKey(notification.id),

                      direction: DismissDirection.endToStart,

                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: Colors.white,
                        ),
                      ),

                      onDismissed: (_) {
                        notifier.delete(notification.id);
                      },

                      child: NotificationCard(
                        notification: notification,
                        onTap: () {
                          notifier.markAsRead(notification.id);

                          if (notification.type.isNavigable) {
                            // TODO
                            // context.push(notification.type.route!);
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<NotificationModel> _todayNotifications(
    List<NotificationModel> notifications,
  ) {
    final now = DateTime.now();

    return notifications
        .where(
          (notification) =>
              notification.createdAt.year == now.year &&
              notification.createdAt.month == now.month &&
              notification.createdAt.day == now.day,
        )
        .toList();
  }

  List<NotificationModel> _yesterdayNotifications(
    List<NotificationModel> notifications,
  ) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return notifications
        .where(
          (notification) =>
              notification.createdAt.year == yesterday.year &&
              notification.createdAt.month == yesterday.month &&
              notification.createdAt.day == yesterday.day,
        )
        .toList();
  }

  List<NotificationModel> _thisWeekNotifications(
    List<NotificationModel> notifications,
  ) {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    return notifications
        .where(
          (notification) =>
              notification.createdAt.isAfter(weekAgo) &&
              !_todayNotifications(notifications).contains(notification) &&
              !_yesterdayNotifications(notifications).contains(notification),
        )
        .toList();
  }
}
