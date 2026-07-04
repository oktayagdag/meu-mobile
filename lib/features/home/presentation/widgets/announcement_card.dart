import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/announcement_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    required this.announcement,
    super.key,
    this.onTap,
  });

  final AnnouncementEntity announcement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconContainer(
            icon: Icons.campaign_rounded,
            iconColor: AppColors.warning,
            backgroundColor: AppColors.warning.withValues(alpha: 0.12),
            size: 50,
            iconSize: 26,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusBadge(
                      text: announcement.category,
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    ),
                    const Spacer(),
                    Text(
                      announcement.date,
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
                  style: textTheme.titleMedium,
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
}