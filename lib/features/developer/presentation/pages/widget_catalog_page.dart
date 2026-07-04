import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/campus_hero_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/next_ring_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/buttons/app_button.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class WidgetCatalogPage extends StatelessWidget {
  const WidgetCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    const mockFood = FoodEntity(
      day: 'Çarşamba',
      date: '30 Haziran 2026',
      totalCalories: 820,
      items: [
        FoodMenuItemEntity(
          name: 'Mercimek Çorbası',
          calories: 120,
          icon: '🍲',
        ),
        FoodMenuItemEntity(
          name: 'Tavuk Sote',
          calories: 320,
          icon: '🍗',
        ),
        FoodMenuItemEntity(
          name: 'Pilav',
          calories: 260,
          icon: '🍚',
        ),
        FoodMenuItemEntity(
          name: 'Ayran',
          calories: 120,
          icon: '🥛',
        ),
      ],
    );

    const mockRingRoute = RingRouteEntity(
      from: 'Mühendislik',
      to: 'Çiftlikköy',
      remainingMinute: 14,
      frequencyText: 'Her 30 dakikada bir',
      isFavorite: true,
    );

    const mockAnnouncement = AnnouncementListItemEntity(
      id: 'catalog-announcement',
      title: '2026 Yaz Okulu Başvuruları',
      description: 'Yaz okulu başvuru tarihleri ve detayları yayınlandı.',
      content: 'Duyuru detay içeriği burada görüntülenir.',
      category: AnnouncementCategory.academic,
      timeAgo: 'Bugün',
      publishedAt: '3 Temmuz 2026',
    );

    const mockEvent = CampusEventEntity(
      id: 'catalog-event',
      title: 'Teknoloji Topluluğu Etkinliği',
      description: 'Yapay zeka ve mobil uygulama geliştirme üzerine öğrenci buluşması.',
      content: 'Etkinlik detay içeriği burada görüntülenir.',
      category: CampusEventCategory.community,
      date: 'Bugün',
      time: '14:00',
      location: 'Konferans Salonu',
      organizer: 'Teknoloji Topluluğu',
    );

    const mockQuickActions = [
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
        title: 'Profil',
        icon: Icons.person_rounded,
        route: '/profile',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Catalog'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(title: 'Typography'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Headline Medium',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Title Medium',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Body Medium — MEÜ Mobile tasarım sistemi.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap(AppSpacing.sm),
                  Text(
                    'Secondary Text',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Colors'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: const [
                  _ColorBox(label: 'Primary', color: AppColors.primary),
                  _ColorBox(label: 'Secondary', color: AppColors.secondary),
                  _ColorBox(label: 'Success', color: AppColors.success),
                  _ColorBox(label: 'Warning', color: AppColors.warning),
                  _ColorBox(label: 'Error', color: AppColors.error),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Buttons'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: Column(
                children: [
                  AppButton(
                    text: 'Primary Button',
                    icon: Icons.check_rounded,
                    onPressed: () {},
                  ),
                  const Gap(AppSpacing.sm),
                  AppButton(
                    text: 'Secondary Button',
                    type: AppButtonType.secondary,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Inputs'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: AppSearchField(
                hintText: 'Arama yap...',
                onChanged: (_) {},
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Badges & Icons'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const AppIconContainer(
                    icon: Icons.school_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: Color(0x1A0057D9),
                  ),
                  StatusBadge(
                    text: 'Akademik',
                    foregroundColor: AppColors.success,
                    backgroundColor: AppColors.success.withValues(alpha: 0.12),
                  ),
                  StatusBadge(
                    text: 'Etkinlik',
                    foregroundColor: AppColors.warning,
                    backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                  ),
                  StatusBadge(
                    text: 'Yeni',
                    foregroundColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Empty State'),
            const Gap(AppSpacing.sm),
            const AppCard(
              child: EmptyState(
                title: 'Kayıt bulunamadı',
                description: 'Aramana uygun herhangi bir sonuç bulunamadı.',
                icon: Icons.search_off_rounded,
              ),
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Home Components'),
            const Gap(AppSpacing.sm),
            CampusHeroCard(
              onExploreTap: () {},
            ),
            const Gap(AppSpacing.sm),
            TodayFoodCard(
              food: mockFood,
              onTap: () {},
            ),
            const Gap(AppSpacing.sm),
            NextRingCard(
              route: mockRingRoute,
              onTap: () {},
            ),
            const Gap(AppSpacing.sm),
            AnnouncementCard(
              announcement: mockAnnouncement,
              onTap: () {},
            ),
            const Gap(AppSpacing.sm),
            EventCard(
              event: mockEvent,
              onTap: () {},
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Quick Actions'),
            const Gap(AppSpacing.sm),
            QuickActionGrid(
              actions: mockQuickActions,
              onActionTap: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}