import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class ClubListCard extends StatelessWidget {
  const ClubListCard({
    required this.club,
    super.key,
    this.onTap,
  });

  final StudentClubEntity club;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(club.category);
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconContainer(
            icon: _categoryIcon(club.category),
            iconColor: categoryColor,
            backgroundColor: categoryColor.withValues(alpha: 0.12),
            size: 48,
            iconSize: 25,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  text: club.category.label,
                  foregroundColor: categoryColor,
                  backgroundColor: categoryColor.withValues(alpha: 0.12),
                ),
                const Gap(AppSpacing.sm),
                Text(
                  club.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  club.shortDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.groups_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      '${club.memberCount} üye',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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

  IconData _categoryIcon(StudentClubCategory category) {
    switch (category) {
      case StudentClubCategory.all:
        return Icons.groups_rounded;
      case StudentClubCategory.technology:
        return Icons.memory_rounded;
      case StudentClubCategory.culture:
        return Icons.theater_comedy_rounded;
      case StudentClubCategory.sport:
        return Icons.sports_soccer_rounded;
      case StudentClubCategory.social:
        return Icons.volunteer_activism_rounded;
      case StudentClubCategory.science:
        return Icons.science_rounded;
    }
  }

  Color _categoryColor(StudentClubCategory category) {
    switch (category) {
      case StudentClubCategory.all:
        return AppColors.primary;
      case StudentClubCategory.technology:
        return AppColors.primary;
      case StudentClubCategory.culture:
        return AppColors.warning;
      case StudentClubCategory.sport:
        return AppColors.success;
      case StudentClubCategory.social:
        return AppColors.secondary;
      case StudentClubCategory.science:
        return AppColors.error;
    }
  }
}