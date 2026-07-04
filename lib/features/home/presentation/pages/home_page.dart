import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/application/providers/home_dashboard_provider.dart';
import 'package:meu_mobile/features/home/application/providers/home_mock_provider.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/campus_hero_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/greeting_header.dart';
import 'package:meu_mobile/features/home/presentation/widgets/next_ring_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';
import 'package:meu_mobile/features/profile/application/providers/profile_mock_provider.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final quickActions = ref.watch(quickActionsProvider);

    final todayFood = ref.watch(homeTodayFoodProvider);
    final nextRingRoute = ref.watch(homeNextRingRouteProvider);
    final latestAnnouncement = ref.watch(homeLatestAnnouncementProvider);
    final upcomingEvent = ref.watch(homeUpcomingEventProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingHeader(name: profile.fullName),
              const Gap(AppSpacing.md),

              CampusHeroCard(
                onExploreTap: () {
                  context.go('/clubs');
                },
              ),
              const Gap(AppSpacing.lg),

              const AppSectionTitle(title: 'Kampüste Bugün'),
              const Gap(AppSpacing.sm),

              if (todayFood != null)
                TodayFoodCard(
                  food: todayFood,
                  onTap: () {
                    context.go('/food');
                  },
                ),

              if (todayFood != null && nextRingRoute != null)
                const Gap(AppSpacing.sm),

              if (nextRingRoute != null)
                NextRingCard(
                  route: nextRingRoute,
                  onTap: () {
                    context.go('/ring');
                  },
                ),

              const Gap(AppSpacing.lg),

              const AppSectionTitle(title: 'Hızlı Erişim'),
              const Gap(AppSpacing.sm),
              QuickActionGrid(
                actions: quickActions,
                onActionTap: (route) {
                  context.go(route);
                },
              ),

              if (latestAnnouncement != null) ...[
                const Gap(AppSpacing.lg),
                const AppSectionTitle(title: 'Son Duyuru'),
                const Gap(AppSpacing.sm),
                AnnouncementCard(
                  announcement: latestAnnouncement,
                  onTap: () {
                    context.go('/announcements/${latestAnnouncement.id}');
                  },
                ),
              ],

              if (upcomingEvent != null) ...[
                const Gap(AppSpacing.lg),
                const AppSectionTitle(title: 'Yaklaşan Etkinlik'),
                const Gap(AppSpacing.sm),
                EventCard(
                  event: upcomingEvent,
                  onTap: () {
                    context.go('/events/${upcomingEvent.id}');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}