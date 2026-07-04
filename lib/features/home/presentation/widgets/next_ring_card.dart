import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class NextRingCard extends StatelessWidget {
  const NextRingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      onTap: () {
        context.go('/ring');
      },
      child: Row(
        children: [
          AppIconContainer(
            icon: Icons.directions_bus_rounded,
            iconColor: AppColors.secondary,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonraki Ring', style: textTheme.titleMedium),
                const Gap(AppSpacing.xs),
                Text(
                  'Mühendislik → Çiftlikköy',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                const Gap(AppSpacing.xs),
                Text(
                  'Bugün 14:20',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '12 dk',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
