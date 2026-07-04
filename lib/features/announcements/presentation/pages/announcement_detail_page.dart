import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_mock_provider.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class AnnouncementDetailPage extends ConsumerWidget {
  const AnnouncementDetailPage({
    required this.announcementId,
    super.key,
  });

  final String announcementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsProvider);

    AnnouncementListItemEntity? announcement;

    for (final item in announcements) {
      if (item.id == announcementId) {
        announcement = item;
        break;
      }
    }

    if (announcement == null) {
      return const Scaffold(
        body: EmptyState(
          title: 'Duyuru bulunamadı',
          description: 'Açmak istediğin duyuru kaldırılmış veya güncellenmiş olabilir.',
          icon: Icons.campaign_outlined,
        ),
      );
    }

    final categoryColor = _categoryColor(announcement.category);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyuru Detayı'),
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
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIconContainer(
                        icon: _categoryIcon(announcement.category),
                        iconColor: categoryColor,
                        backgroundColor: categoryColor.withValues(alpha: 0.12),
                        size: 50,
                        iconSize: 26,
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusBadge(
                              text: announcement.category.label,
                              foregroundColor: categoryColor,
                              backgroundColor: categoryColor.withValues(alpha: 0.12),
                            ),
                            const Gap(AppSpacing.xs),
                            Text(
                              announcement.publishedAt,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    announcement.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    announcement.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            AppCard(
              child: Text(
                announcement.content,
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.all:
        return Icons.campaign_rounded;
      case AnnouncementCategory.academic:
        return Icons.school_rounded;
      case AnnouncementCategory.administrative:
        return Icons.account_balance_rounded;
      case AnnouncementCategory.event:
        return Icons.event_rounded;
    }
  }

  Color _categoryColor(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.all:
        return AppColors.primary;
      case AnnouncementCategory.academic:
        return AppColors.success;
      case AnnouncementCategory.administrative:
        return AppColors.primary;
      case AnnouncementCategory.event:
        return AppColors.warning;
    }
  }
}