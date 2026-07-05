import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class CampusLocationCard extends StatelessWidget {
  const CampusLocationCard({
    required this.location,
    super.key,
    this.onTap,
  });

  final CampusLocationEntity location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(location.category);
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconContainer(
            icon: _categoryIcon(location.category),
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
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatusBadge(
                      text: location.category.label,
                      foregroundColor: categoryColor,
                      backgroundColor: categoryColor.withValues(alpha: 0.12),
                    ),
                    StatusBadge(
                      text: location.walkingTime,
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    ),
                  ],
                ),
                const Gap(AppSpacing.sm),
                Text(
                  location.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  location.description,
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
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        location.campus,
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
        return Icons.map_rounded;
      case CampusLocationCategory.faculty:
        return Icons.school_rounded;
      case CampusLocationCategory.library:
        return Icons.local_library_rounded;
      case CampusLocationCategory.cafeteria:
        return Icons.restaurant_menu_rounded;
      case CampusLocationCategory.transport:
        return Icons.directions_bus_rounded;
      case CampusLocationCategory.administrative:
        return Icons.account_balance_rounded;
      case CampusLocationCategory.social:
        return Icons.groups_rounded;
    }
  }

  Color _categoryColor(CampusLocationCategory category) {
    switch (category) {
      case CampusLocationCategory.all:
        return AppColors.primary;
      case CampusLocationCategory.faculty:
        return AppColors.primary;
      case CampusLocationCategory.library:
        return AppColors.secondary;
      case CampusLocationCategory.cafeteria:
        return AppColors.warning;
      case CampusLocationCategory.transport:
        return AppColors.success;
      case CampusLocationCategory.administrative:
        return AppColors.primary;
      case CampusLocationCategory.social:
        return AppColors.error;
    }
  }
}