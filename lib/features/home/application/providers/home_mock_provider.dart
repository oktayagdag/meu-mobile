import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';

final quickActionsProvider = Provider<List<QuickActionEntity>>((ref) {
  return const [
     QuickActionEntity(
      title: 'Akademik Takvim',
      icon: Icons.calendar_month_rounded,
      route: '/academic-calendar',
    ),
    QuickActionEntity(
      title: 'Harita',
      icon: Icons.map_rounded,
      route: '/campus-map',
    ),
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
  ];
});