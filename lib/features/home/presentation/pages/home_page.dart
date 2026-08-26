import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/providers/side_menu_controller_provider.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/application/providers/home_dashboard_provider.dart';
import 'package:meu_mobile/features/home/application/providers/home_resources_provider.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/features/home/presentation/widgets/academic_stats_section.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_extra_quick_actions.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_global_search_bar.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_hero_slider.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_social_links_section.dart';
import 'package:meu_mobile/features/home/presentation/widgets/live_transit_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          _HomeTopBar(
            onMenuTap: () {
              ref.read(sideMenuControllerProvider.notifier).toggle();
            },
            onNotificationTap: () {
              context.push('/notifications');
            },
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                12,
                AppSpacing.md,
                28,
              ),
              children: [
                const _HomeSearchSection(),
                const Gap(10),
                HomeHeroSlider(
                  onExploreTap: () {
                    context.go('/campus-map');
                  },
                ),
                const Gap(AppSpacing.homeSectionTop),
                const HomeSectionTitle(title: 'Kampüste Bugün'),
                const Gap(AppSpacing.homeSectionContent),
                const _TodayFoodSection(),
                const Gap(8),
                LiveTransitCard(
                  onTap: () {
                    context.go('/ring');
                  },
                ),
                const Gap(AppSpacing.homeSectionTop),
                const HomeSectionTitle(title: 'Hızlı Erişim'),
                const Gap(AppSpacing.homeSectionContent),
                const QuickActionGrid(),
                const _HomeExtraQuickActionsSection(),
                const _LatestAnnouncementSection(),
                const _UpcomingEventSection(),
                const _AcademicStatsHomeSection(),
                const Gap(AppSpacing.homeSectionTop),
                const HomeSocialLinksSection(),
                const Gap(8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSearchSection extends ConsumerWidget {
  const _HomeSearchSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(homeResourcesProvider);

    return HomeGlobalSearchBar(resources: resourcesAsync.asData?.value);
  }
}

class _TodayFoodSection extends ConsumerWidget {
  const _TodayFoodSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(homeTodayFoodProvider);

    return foodAsync.when(
      data: (food) {
        if (food == null) {
          return const SizedBox.shrink();
        }

        return TodayFoodCard(
          food: food,
          onTap: () {
            context.go('/food');
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _HomeExtraQuickActionsSection extends ConsumerWidget {
  const _HomeExtraQuickActionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(homeResourcesProvider);

    return resourcesAsync.when(
      data: (resources) {
        if (resources.quickActions.isEmpty) {
          return const SizedBox.shrink();
        }

        return HomeExtraQuickActions(items: resources.quickActions);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _LatestAnnouncementSection extends ConsumerWidget {
  const _LatestAnnouncementSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementAsync = ref.watch(homeLatestAnnouncementProvider);

    return announcementAsync.when(
      data: (announcement) {
        if (announcement == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(AppSpacing.homeSectionTop),
            const HomeSectionTitle(title: 'Son Duyuru'),
            const Gap(AppSpacing.homeSectionContent),
            AnnouncementCard(
              announcement: announcement,
              onTap: () {
                context.push('/announcements/${announcement.id}');
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _UpcomingEventSection extends ConsumerWidget {
  const _UpcomingEventSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(homeUpcomingEventProvider);

    return eventAsync.when(
      data: (event) {
        if (event == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(AppSpacing.homeSectionTop),
            const HomeSectionTitle(title: 'Yaklaşan Etkinlik'),
            const Gap(AppSpacing.homeSectionContent),
            EventCard(
              event: event,
              onTap: () {
                context.push('/events/${event.id}');
              },
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _AcademicStatsHomeSection extends ConsumerWidget {
  const _AcademicStatsHomeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resourcesAsync = ref.watch(homeResourcesProvider);

    return resourcesAsync.when(
      data: (resources) {
        if (resources.academicStats.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(AppSpacing.homeSectionTop),
            AcademicStatsSection(items: resources.academicStats),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.onMenuTap, required this.onNotificationTap});

  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    const sideAreaWidth = 74.0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [HomeDesignTokens.navy, HomeDesignTokens.deepNavy],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            8,
            AppSpacing.md,
            9,
          ),
          child: Row(
            children: [
              SizedBox(
                width: sideAreaWidth,
                height: 42,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onMenuTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Image.asset(
                              'assets/images/meu_logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.account_balance_rounded,
                                  color: Colors.white,
                                  size: 22,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'MEUMOBİL',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 19,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: sideAreaWidth,
                height: 42,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.10),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Bildirimler',
                      onPressed: onNotificationTap,
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
