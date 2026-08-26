import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: .08)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: notification.type.color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  notification.type.icon,
                  color: notification.type.color,
                  size: 22,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          _formatTime(notification.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      notification.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.35,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: notification.type.color.withValues(
                              alpha: .10,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            notification.type.label,
                            style: TextStyle(
                              color: notification.type.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        const Spacer(),

                        if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1743A),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Şimdi";
    }

    if (difference.inHours < 1) {
      return "${difference.inMinutes} dk";
    }

    if (difference.inDays < 1) {
      return "${difference.inHours} sa";
    }

    return DateFormat("dd.MM.yyyy", "tr").format(date);
  }
}