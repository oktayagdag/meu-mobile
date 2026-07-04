import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/event_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
    this.onTap,
  });

  final EventEntity event;
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
            icon: Icons.event_available_rounded,
            iconColor: AppColors.secondary,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
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
                      text: event.date,
                      foregroundColor: AppColors.secondary,
                      backgroundColor:
                          AppColors.secondary.withValues(alpha: 0.12),
                    ),
                    const Gap(AppSpacing.sm),
                    StatusBadge(
                      text: event.time,
                      foregroundColor: AppColors.success,
                      backgroundColor: AppColors.success.withValues(alpha: 0.12),
                    ),
                  ],
                ),
                const Gap(AppSpacing.sm),
                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                const Gap(AppSpacing.xs),
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
                        event.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
}