import 'package:flutter/material.dart';

enum NotificationType {
  announcement(
    label: 'Duyuru',
    icon: Icons.campaign_rounded,
    color: Color(0xFF182958),
    route: '/announcements',
  ),

  event(
    label: 'Etkinlik',
    icon: Icons.event_rounded,
    color: Color(0xFFF1743A),
    route: '/events',
  ),

  cafeteria(
    label: 'Yemekhane',
    icon: Icons.restaurant_rounded,
    color: Color(0xFF2E9D57),
    route: '/cafeteria',
  ),

  community(
    label: 'Topluluk',
    icon: Icons.groups_rounded,
    color: Color(0xFF7C64D5),
    route: '/clubs',
  ),

  transportation(
    label: 'Ulaşım',
    icon: Icons.directions_bus_rounded,
    color: Color(0xFF008C95),
    route: '/transportation',
  ),

  map(
    label: 'Kampüs Haritası',
    icon: Icons.map_rounded,
    color: Color(0xFF008C95),
    route: '/campus-map',
  ),

  system(
    label: 'Sistem',
    icon: Icons.notifications_active_rounded,
    color: Color(0xFF64748B),
    route: null,
  );

  const NotificationType({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  /// Kullanıcıya gösterilecek isim
  final String label;

  /// Bildirim ikonu
  final IconData icon;

  /// Bildirim vurgu rengi
  final Color color;

  /// Varsayılan yönlendirme
  final String? route;

  /// Kullanıcı etkileşimi gerektiriyor mu?
  bool get isNavigable => route != null;
}
