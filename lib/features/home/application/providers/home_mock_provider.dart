import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';

final quickActionsProvider = Provider<List<QuickActionEntity>>((ref) {
  return const [
    QuickActionEntity(
      title: 'Yemek',
      icon: Icons.restaurant_menu_rounded,
      route: '/food',
    ),
    QuickActionEntity(
      title: 'Ring',
      icon: Icons.directions_bus_rounded,
      route: '/ring',
    ),
    QuickActionEntity(
      title: 'Duyurular',
      icon: Icons.campaign_rounded,
      route: '/announcements',
    ),
    QuickActionEntity(
      title: 'Etkinlikler',
      icon: Icons.event_rounded,
      route: '/events',
    ),
    QuickActionEntity(
      title: 'Topluluklar',
      icon: Icons.groups_rounded,
      route: '/clubs',
    ),
    QuickActionEntity(
      title: 'Profil',
      icon: Icons.person_rounded,
      route: '/profile',
    ),
  ];
});