import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/home/domain/entities/announcement_entity.dart';
import 'package:meu_mobile/features/home/domain/entities/event_entity.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';

final quickActionsProvider = Provider<List<QuickActionEntity>>((ref) {
  return const [
    QuickActionEntity(
      title: 'Yemek',
      icon: Icons.restaurant_rounded,
      route: '/food',
    ),
    QuickActionEntity(
      title: 'Ring',
      icon: Icons.directions_bus_rounded,
      route: '/ring',
    ),
    QuickActionEntity(
      title: 'Duyuru',
      icon: Icons.campaign_rounded,
      route: '/announcements',
    ),
    QuickActionEntity(
      title: 'Etkinlik',
      icon: Icons.event_rounded,
      route: '/events',
    ),
    QuickActionEntity(
      title: 'Topluluk',
      icon: Icons.groups_rounded,
      route: '/clubs',
    ),
    QuickActionEntity(
      title: 'Takvim',
      icon: Icons.calendar_month_rounded,
      route: '/calendar',
    ),
  ];
});

final latestAnnouncementProvider = Provider<AnnouncementEntity>((ref) {
  return const AnnouncementEntity(
    title: '2026 Yaz Okulu Başvuruları',
    description: 'Yaz okulu başvuru tarihleri ve detayları yayınlandı.',
    category: 'Akademik',
    date: 'Bugün',
  );
});

final upcomingEventProvider = Provider<EventEntity>((ref) {
  return const EventEntity(
    title: 'Teknoloji Topluluğu Etkinliği',
    location: 'Konferans Salonu',
    date: 'Bugün',
    time: '14:00',
  );
});