import 'package:flutter/material.dart';

import '../domain/notification_type.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
    required this.type,
    this.size = 52,
    this.iconSize = 26,
  });

  final NotificationType type;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(type.icon, color: type.color, size: iconSize),
    );
  }
}
