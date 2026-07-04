import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class CampusHeroCard extends StatelessWidget {
  const CampusHeroCard({
    super.key,
    this.onExploreTap,
  });

  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary.withValues(alpha: 0.92),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 34,
            ),
            const Gap(AppSpacing.md),
            Text(
              'MEÜ Mobile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              'Yemekhane, ring, duyurular, etkinlikler ve topluluklar tek yerde.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                    height: 1.4,
                  ),
            ),
            const Gap(AppSpacing.md),
            InkWell(
              onTap: onExploreTap,
              borderRadius: AppRadius.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.24),
                  ),
                ),
                child: Text(
                  'Kampüsü keşfet',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}