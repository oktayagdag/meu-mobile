import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/dashboard_section.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/greeting_header.dart';
import 'package:meu_mobile/features/home/presentation/widgets/next_ring_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(),
              Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Bugün Kampüste',
                child: Column(
                  children: [
                    TodayFoodCard(),
                    Gap(AppSpacing.sm),
                    NextRingCard(),
                  ],
                ),
              ),
              Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Hızlı Erişim',
                child: QuickActionGrid(),
              ),
              Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Son Duyurular',
                actionText: 'Tümü',
                child: AnnouncementCard(),
              ),
              Gap(AppSpacing.lg),
              DashboardSection(
                title: 'Yaklaşan Etkinlik',
                actionText: 'Tümü',
                child: EventCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}