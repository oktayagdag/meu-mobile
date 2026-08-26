import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';

class TodayFoodCard extends StatelessWidget {
  const TodayFoodCard({
    required this.food,
    required this.onTap,
    super.key,
  });

  final FoodEntity food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (food.isHoliday) {
      return _HolidayFoodCard(
        food: food,
        onTap: onTap,
      );
    }

    final menuItems = <String>[
      if (_hasText(food.mainDish)) food.mainDish!,
      if (_hasText(food.firstSideDish)) food.firstSideDish!,
      if (_hasText(food.secondSideDish)) food.secondSideDish!,
      if (_hasText(food.thirdItem)) food.thirdItem!,
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            accent: HomeDesignTokens.orange,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: HomeDesignTokens.orange.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: HomeDesignTokens.orange,
                  size: 24,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Bugünün Menüsü',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color:
                                      HomeDesignTokens.primaryText(context),
                                  fontSize: 14,
                                  height: 1.1,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ),
                        if (food.totalCalories != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: HomeDesignTokens.orange
                                  .withValues(alpha: 0.09),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '${food.totalCalories} kcal',
                              style: const TextStyle(
                                color: HomeDesignTokens.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(4),
                    Text(
                      '${food.day} • ${food.displayDate}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.secondaryText(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Gap(8),
                    Text(
                      menuItems.join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.primaryText(context),
                            fontSize: 12.2,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (_hasText(food.vegetarianDish)) ...[
                      const Gap(6),
                      Row(
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            size: 14,
                            color: HomeDesignTokens.green,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Vejetaryen: ${food.vegetarianDish}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: HomeDesignTokens.secondaryText(
                                      context,
                                    ),
                                    fontSize: 10.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color:
                      HomeDesignTokens.orange.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: HomeDesignTokens.orange,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _HolidayFoodCard extends StatelessWidget {
  const _HolidayFoodCard({
    required this.food,
    required this.onTap,
  });

  final FoodEntity food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const holidayColor = Color(0xFFD94D4D);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            accent: holidayColor,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: holidayColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.event_busy_rounded,
                  color: holidayColor,
                  size: 24,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bugünün Menüsü',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.primaryText(context),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Gap(4),
                    Text(
                      food.holidayName ?? 'Resmi Tatil',
                      style: const TextStyle(
                        color: holidayColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '${food.day} • ${food.displayDate}',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.secondaryText(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: holidayColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
