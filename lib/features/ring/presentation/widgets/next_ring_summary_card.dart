import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class NextRingSummaryCard extends StatelessWidget {
  const NextRingSummaryCard({
    required this.ring,
    super.key,
  });

  final RingRouteEntity ring;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: AppRadius.lg,
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: AppColors.primary,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonraki Ring', style: textTheme.titleMedium),
                const Gap(AppSpacing.xs),
                Text(
                  '${ring.from} → ${ring.to}',
                  style: textTheme.bodyMedium,
                ),
                const Gap(AppSpacing.xs),
                Text(
                  'Bugün ${ring.time}',
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Text(
            '${ring.remainingMinute} dk',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}