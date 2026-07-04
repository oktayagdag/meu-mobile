import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class AnnouncementListCard extends StatelessWidget {
  const AnnouncementListCard({
    required this.announcement,
    super.key,
    this.onTap,
  });

  final AnnouncementListItemEntity announcement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(announcement.category);
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconContainer(
            icon: _categoryIcon(announcement.category),
            iconColor: categoryColor,
            backgroundColor: categoryColor.withValues(alpha: 0.12),
            size: 46,
            iconSize: 24,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusBadge(
                      text: announcement.category.label,
                      foregroundColor: categoryColor,
                      backgroundColor: categoryColor.withValues(alpha: 0.12),
                    ),
                    const Spacer(),
                    Text(
                      announcement.timeAgo,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Gap(AppSpacing.sm),
                Text(
                  announcement.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  announcement.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
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