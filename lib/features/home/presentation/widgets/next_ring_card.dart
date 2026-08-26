import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class NextRingCard extends StatelessWidget {
  const NextRingCard({required this.route, super.key, this.onTap});

  final RingRouteEntity route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          AppIconContainer(
            icon: Icons.directions_bus_rounded,
            iconColor: AppColors.success,
            backgroundColor: AppColors.success.withValues(alpha: 0.12),
            size: 48,
            iconSize: 25,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sıradaki Ring',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 16,
                    height: 1.10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  route.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            '${route.remainingMinute} dk',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
