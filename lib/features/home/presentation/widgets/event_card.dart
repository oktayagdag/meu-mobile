import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
    this.onTap,
  });

  final CampusEventEntity event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(event.category);
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconContainer(
            icon: _categoryIcon(event.category),
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
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    StatusBadge(
                      text: event.category.label,
                      foregroundColor: categoryColor,
                      backgroundColor: categoryColor.withValues(alpha: 0.12),
                    ),
                    StatusBadge(
                      text: event.date,
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                    ),
                  ],
                ),
                const Gap(AppSpacing.sm),
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  '${event.time} • ${event.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
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

  IconData _categoryIcon(CampusEventCategory category) {
    switch (category) {
      case CampusEventCategory.all:
        return Icons.event_rounded;
      case CampusEventCategory.conference:
        return Icons.mic_rounded;
      case CampusEventCategory.community:
        return Icons.groups_rounded;
      case CampusEventCategory.culture:
        return Icons.theater_comedy_rounded;
      case CampusEventCategory.sport:
        return Icons.sports_soccer_rounded;
    }
  }

  Color _categoryColor(CampusEventCategory category) {
    switch (category) {
      case CampusEventCategory.all:
        return AppColors.primary;
      case CampusEventCategory.conference:
        return AppColors.primary;
      case CampusEventCategory.community:
        return AppColors.secondary;
      case CampusEventCategory.culture:
        return AppColors.warning;
      case CampusEventCategory.sport:
        return AppColors.success;
    }
  }
}