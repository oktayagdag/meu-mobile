import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/announcement_entity.dart';
import 'package:meu_mobile/features/home/domain/entities/event_entity.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';
import 'package:meu_mobile/features/home/presentation/widgets/announcement_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/campus_hero_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/event_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/next_ring_card.dart';
import 'package:meu_mobile/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:meu_mobile/features/home/presentation/widgets/today_food_card.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/buttons/app_button.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/loaders/app_loading_indicator.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class WidgetCatalogPage extends StatelessWidget {
  const WidgetCatalogPage({super.key});

  static const _sampleAnnouncement = AnnouncementEntity(
    title: '2026 Yaz Okulu Başvuruları',
    description: 'Yaz okulu başvuru tarihleri ve detayları yayınlandı.',
    category: 'Akademik',
    date: 'Bugün',
  );

  static const _sampleEvent = EventEntity(
    title: 'Teknoloji Topluluğu Etkinliği',
    location: 'Konferans Salonu',
    date: 'Bugün',
    time: '14:00',
  );

  static const _sampleQuickActions = [
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MEÜ UI Kit'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppSectionTitle(title: 'Typography'),
          const Gap(AppSpacing.sm),
          Text('Headline Large', style: textTheme.headlineLarge),
          Text('Headline Medium', style: textTheme.headlineMedium),
          Text('Title Large', style: textTheme.titleLarge),
          Text('Body Large', style: textTheme.bodyLarge),
          Text('Body Medium', style: textTheme.bodyMedium),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Colors'),
          const Gap(AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ColorBox(label: 'Primary', color: AppColors.primary),
              _ColorBox(label: 'Secondary', color: AppColors.secondary),
              _ColorBox(label: 'Success', color: AppColors.success),
              _ColorBox(label: 'Warning', color: AppColors.warning),
              _ColorBox(label: 'Error', color: AppColors.error),
            ],
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Buttons'),
          const Gap(AppSpacing.sm),
          AppButton(
            text: 'Primary Button',
            icon: Icons.check,
            onPressed: () {},
          ),
          const Gap(AppSpacing.sm),
          AppButton(
            text: 'Secondary Button',
            type: AppButtonType.secondary,
            icon: Icons.edit,
            onPressed: () {},
          ),
          const Gap(AppSpacing.sm),
          const AppButton(
            text: 'Loading Button',
            isLoading: true,
            onPressed: null,
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Cards'),
          const Gap(AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('App Card', style: textTheme.titleMedium),
                const Gap(AppSpacing.sm),
                Text(
                  'Bu kart uygulama genelindeki standart kart bileşenidir.',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Badges & Icons'),
          const Gap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppIconContainer(
                icon: Icons.restaurant_menu_rounded,
                iconColor: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.10),
              ),
              AppIconContainer(
                icon: Icons.directions_bus_rounded,
                iconColor: AppColors.secondary,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
              ),
              StatusBadge(
                text: 'Akademik',
                foregroundColor: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.10),
              ),
              StatusBadge(
                text: 'Bugün',
                foregroundColor: AppColors.success,
                backgroundColor: AppColors.success.withValues(alpha: 0.12),
              ),
            ],
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Inputs'),
          const Gap(AppSpacing.sm),
          const AppSearchField(
            hintText: 'Duyuru, etkinlik veya topluluk ara...',
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Loading'),
          const SizedBox(
            height: 120,
            child: AppLoadingIndicator(),
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Empty State'),
          const Gap(AppSpacing.sm),
          const EmptyState(
            title: 'Kayıt bulunamadı',
            description: 'Aradığın içerik henüz eklenmemiş olabilir.',
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Home Components'),
          const Gap(AppSpacing.sm),
          const CampusHeroCard(),
          const Gap(AppSpacing.sm),
          const TodayFoodCard(),
          const Gap(AppSpacing.sm),
          const NextRingCard(),
          const Gap(AppSpacing.sm),
          const AnnouncementCard(
            announcement: _sampleAnnouncement,
          ),
          const Gap(AppSpacing.sm),
          const EventCard(
            event: _sampleEvent,
          ),
          const Gap(AppSpacing.lg),

          const AppSectionTitle(title: 'Quick Actions'),
          const Gap(AppSpacing.sm),
          const QuickActionGrid(items: _sampleQuickActions),
        ],
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
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: SizedBox(
        width: 96,
        child: Column(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const Gap(AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}