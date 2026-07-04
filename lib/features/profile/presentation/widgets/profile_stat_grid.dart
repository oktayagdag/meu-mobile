import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/profile/domain/entities/user_profile_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class ProfileStatGrid extends StatelessWidget {
  const ProfileStatGrid({
    required this.stats,
    super.key,
  });

  final List<ProfileStatEntity> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stats.length, (index) {
        final stat = stats[index];

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == stats.length - 1 ? 0 : AppSpacing.sm,
            ),
            child: _ProfileStatCard(stat: stat),
          ),
        );
      }),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.stat,
  });

  final ProfileStatEntity stat;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          Text(
            stat.value,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Gap(AppSpacing.xs),
          Text(
            stat.title,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}