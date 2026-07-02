import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/application/providers/home_mock_provider.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/dashboard_section.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/greeting_header.dart';
import 'package:meu_mobile/features/home/presentation/widgets/next_ring_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickActions = ref.watch(quickActionsProvider);
    final latestAnnouncement = ref.watch(latestAnnouncementProvider);
    final upcomingEvent = ref.watch(upcomingEventProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const Gap(AppSpacing.lg),
              const DashboardSection(
                title: 'Bugün Kampüste',
                child: Column(
                  children: [
                    TodayFoodCard(),
                    Gap(AppSpacing.sm),
                    NextRingCard(),
                  ],
                ),
              ),
              const Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Hızlı Erişim',
                child: QuickActionGrid(items: quickActions),
              ),
              const Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Son Duyurular',
                actionText: 'Tümü',
                child: AnnouncementCard(announcement: latestAnnouncement),
              ),
              const Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Yaklaşan Etkinlik',
                actionText: 'Tümü',
                child: EventCard(event: upcomingEvent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}