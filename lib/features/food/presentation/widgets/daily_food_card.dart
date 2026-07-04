import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class DailyFoodCard extends StatelessWidget {
  const DailyFoodCard({
    required this.food,
    super.key,
  });

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: AppRadius.lg,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primary,
                ),
              ),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bugünkü Menü', style: textTheme.titleMedium),
                    const Gap(AppSpacing.xs),
                    Text('${food.day} • ${food.date}', style: textTheme.bodyMedium),
                  ],
                ),
              ),
              if (food.calories != null)
                Text(
                  '${food.calories} kcal',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const Gap(AppSpacing.md),
          ...food.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                  const Gap(AppSpacing.sm),
                  Expanded(
                    child: Text(item, style: textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}