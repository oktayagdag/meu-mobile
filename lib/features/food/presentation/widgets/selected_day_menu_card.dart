import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

const _foodBlue = Color(0xFF182958);
const _foodOrange = Color(0xFFF1743A);

class SelectedDayMenuCard extends StatelessWidget {
  const SelectedDayMenuCard({
    required this.food,
    super.key,
  });

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    if (food.isHoliday) {
      return _HolidayCard(
        food: food,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _foodBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _foodBlue.withValues(
              alpha: 0.20,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.day.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.35,
                      ),
                    ),

                    const Gap(4),

                    Text(
                      food.displayDate,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: 0.62,
                        ),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              if (food.totalCalories != null)
                _CaloriesBadge(
                  calories: food.totalCalories!,
                ),
            ],
          ),

          const Gap(20),

          Container(
            height: 1,
            color: Colors.white.withValues(
              alpha: 0.10,
            ),
          ),

          const Gap(18),

          _MenuRow(
            icon: Icons.restaurant_rounded,
            title: 'Ana Yemek',
            value: food.mainDish,
            highlighted: true,
          ),

          _MenuRow(
            icon: Icons.rice_bowl_rounded,
            title: '1. Yardımcı Yemek',
            value: food.firstSideDish,
          ),

          _MenuRow(
            icon: Icons.soup_kitchen_rounded,
            title: '2. Yardımcı Yemek',
            value: food.secondSideDish,
          ),

          _MenuRow(
            icon: Icons.local_dining_rounded,
            title: '3. Çeşit',
            value: food.thirdItem,
          ),

          if (_hasText(
            food.vegetarianDish,
          )) ...[
            const Gap(4),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                13,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.07,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.09,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(
                        11,
                      ),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ),

                  const Gap(11),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VEJETARYEN MENÜ',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.4,
                          ),
                        ),

                        const Gap(3),

                        Text(
                          food.vegetarianDish!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (food.meatMixGrams != null) ...[
            const Gap(14),

            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: Colors.white.withValues(
                    alpha: 0.48,
                  ),
                ),

                const Gap(6),

                Text(
                  'Et Mix: ${food.meatMixGrams} g',
                  style: TextStyle(
                    color: Colors.white.withValues(
                      alpha: 0.52,
                    ),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.value,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String? value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: highlighted
                  ? _foodOrange.withValues(
                      alpha: 0.18,
                    )
                  : Colors.white.withValues(
                      alpha: 0.08,
                    ),
              borderRadius: BorderRadius.circular(
                12,
              ),
              border: Border.all(
                color: highlighted
                    ? _foodOrange.withValues(
                        alpha: 0.32,
                      )
                    : Colors.white.withValues(
                        alpha: 0.06,
                      ),
              ),
            ),
            child: Icon(
              icon,
              color: highlighted
                  ? _foodOrange
                  : Colors.white.withValues(
                      alpha: 0.82,
                    ),
              size: 21,
            ),
          ),

          const Gap(12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlighted
                        ? _foodOrange
                        : Colors.white.withValues(
                            alpha: 0.50,
                          ),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),

                const Gap(3),

                Text(
                  value!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
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

class _CaloriesBadge extends StatelessWidget {
  const _CaloriesBadge({
    required this.calories,
  });

  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: _foodOrange,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: _foodOrange.withValues(
              alpha: 0.24,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 14,
            color: Colors.white,
          ),

          const Gap(4),

          Text(
            '$calories kcal',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _HolidayCard extends StatelessWidget {
  const _HolidayCard({
    required this.food,
  });

  final FoodEntity food;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _foodBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _foodBlue.withValues(
              alpha: 0.20,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _foodOrange.withValues(
                alpha: 0.16,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: _foodOrange.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
            child: const Icon(
              Icons.event_busy_rounded,
              color: _foodOrange,
              size: 27,
            ),
          ),

          const Gap(14),

          Text(
            food.holidayName ?? 'Resmi Tatil',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const Gap(5),

          Text(
            '${food.day} • ${food.displayDate}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.58,
              ),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Gap(8),

          Text(
            'Bu tarih için yemekhane hizmeti bulunmuyor.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(
                alpha: 0.68,
              ),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
