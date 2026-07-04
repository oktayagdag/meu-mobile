import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class RingScheduleList extends StatelessWidget {
  const RingScheduleList({
    required this.routes,
    super.key,
  });

  final List<RingRouteEntity> routes;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: routes.map((route) {
          final isFirst = route == routes.first;
          final isLast = route == routes.last;

          return Column(
            children: [
              _RingScheduleTile(
                route: route,
                isHighlighted: isFirst,
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: AppSpacing.md,
                  endIndent: AppSpacing.md,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _RingScheduleTile extends StatelessWidget {
  const _RingScheduleTile({
    required this.route,
    required this.isHighlighted,
  });

  final RingRouteEntity route;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      color: isHighlighted ? AppColors.primary.withValues(alpha: 0.06) : null,
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              route.time,
              style: textTheme.titleMedium?.copyWith(
                color: isHighlighted ? AppColors.primary : null,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${route.from} → ${route.to}',
                  style: textTheme.bodyLarge,
                ),
                const Gap(AppSpacing.xs),
                Text(
                  '${route.remainingMinute} dakika sonra',
                  style: textTheme.labelSmall?.copyWith(
                    color: isHighlighted
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}