import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/profile/application/providers/profile_mock_provider.dart';
import 'package:meu_mobile/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:meu_mobile/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:meu_mobile/features/profile/presentation/widgets/profile_stat_grid.dart';
import 'package:meu_mobile/features/profile/presentation/widgets/profile_switch_tile.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';
import 'package:meu_mobile/app/constants/app_info.dart';
import 'package:meu_mobile/shared/utils/app_feedback.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final stats = ref.watch(profileStatsProvider);
    final announcementNotifications = ref.watch(
      announcementNotificationProvider,
    );
    final cafeteriaReminder = ref.watch(cafeteriaReminderProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
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
            ProfileHeaderCard(profile: profile),
            const Gap(AppSpacing.md),

            ProfileStatGrid(stats: stats),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Hesap'),
            const Gap(AppSpacing.sm),
            ProfileMenuTile(
              icon: Icons.badge_rounded,
              title: 'Öğrenci Bilgileri',
              description: '${profile.studentNumber} • ${profile.email}',
              onTap: () {
                showComingSoonSnackBar(
                  context,
                  featureName: 'Öğrenci bilgileri',
                );
              },
            ),
            const Gap(AppSpacing.sm),
            ProfileMenuTile(
              icon: Icons.favorite_rounded,
              title: 'Favorilerim',
              description: 'Favori ring hatları ve takip edilen içerikler',
              onTap: () {
                showComingSoonSnackBar(context, featureName: 'Favorilerim');
              },
            ),
            const Gap(AppSpacing.sm),
            ProfileMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Yardım ve Geri Bildirim',
              description: 'Uygulama hakkında görüş bildir',
              onTap: () {
                showComingSoonSnackBar(
                  context,
                  featureName: 'Yardım ve geri bildirim',
                );
              },
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Ayarlar'),
            const Gap(AppSpacing.sm),
            ProfileSwitchTile(
              icon: Icons.notifications_active_rounded,
              title: 'Duyuru Bildirimleri',
              description: 'Yeni duyurulardan haberdar ol',
              value: announcementNotifications,
              onChanged: (value) {
                ref
                    .read(announcementNotificationProvider.notifier)
                    .toggle(value);
              },
            ),
            const Gap(AppSpacing.sm),
            ProfileSwitchTile(
              icon: Icons.restaurant_menu_rounded,
              title: 'Yemekhane Hatırlatıcı',
              description: 'Günün menüsü için hatırlatma al',
              value: cafeteriaReminder,
              onChanged: (value) {
                ref.read(cafeteriaReminderProvider.notifier).toggle(value);
              },
            ),
            const Gap(AppSpacing.lg),

            const AppSectionTitle(title: 'Uygulama'),
            const Gap(AppSpacing.sm),
            AppCard(
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Text(
                      '${AppInfo.appName} v${AppInfo.version}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    AppInfo.stage,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
