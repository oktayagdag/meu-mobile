import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class RingRouteCard extends StatelessWidget {
  const RingRouteCard({required this.route, super.key});

  final RingRouteEntity route;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: () {},
      child: Row(
        children: [
          AppIconContainer(
            icon: Icons.directions_bus_rounded,
            iconColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            size: 44,
            iconSize: 22,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  route.frequencyText,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
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
