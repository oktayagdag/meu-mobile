import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class WeeklyFoodList extends StatelessWidget {
  const WeeklyFoodList({
    required this.foods,
    required this.todayDay,
    super.key,
  });

  final List<FoodEntity> foods;
  final String todayDay;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: foods.map((food) {
          final isToday = food.day == todayDay;
          final isLast = food == foods.last;

          return _WeeklyFoodTile(
            food: food,
            isToday: isToday,
            showDivider: !isLast,
          );
        }).toList(),
      ),
    );
  }
}

class _WeeklyFoodTile extends StatelessWidget {
  const _WeeklyFoodTile({
    required this.food,
    required this.isToday,
    required this.showDivider,
  });

  final FoodEntity food;
  final bool isToday;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary.withValues(alpha: 0.06) : null,
            borderRadius: isToday ? AppRadius.lg : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DayBox(day: food.day, isToday: isToday),
              const Gap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(food.day, style: textTheme.titleMedium),
                        const Gap(AppSpacing.sm),
                        if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: AppRadius.sm,
                            ),
                            child: Text(
                              'BUGÜN',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(AppSpacing.xs),
                    Text(food.date, style: textTheme.bodyMedium),
                    const Gap(AppSpacing.sm),
                    Text(
                      food.items.join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (food.calories != null)
                Text(
                  '${food.calories} kcal',
                  style: textTheme.labelSmall?.copyWith(
                    color: isToday ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),
      ],
    );
  }
}

class _DayBox extends StatelessWidget {
  const _DayBox({
    required this.day,
    required this.isToday,
  });

  final String day;
  final bool isToday;

  String get shortDay {
    switch (day) {
      case 'Pazartesi':
        return 'Pzt';
      case 'Salı':
        return 'Sal';
      case 'Çarşamba':
        return 'Çar';
      case 'Perşembe':
        return 'Per';
      case 'Cuma':
        return 'Cum';
      default:
        return day.substring(0, 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.md,
      ),
      child: Text(
        shortDay,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isToday ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}