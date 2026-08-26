import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';

const _foodBlue = Color(0xFF182958);
const _foodOrange = Color(0xFFF1743A);

class FoodSelectorCard extends StatelessWidget {
  const FoodSelectorCard({
    required this.foods,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<FoodEntity> foods;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: AppSpacing.sm,
          );
        },
        itemBuilder: (context, index) {
          final food = foods[index];
          final selected = index == selectedIndex;

          return _DayItem(
            food: food,
            selected: selected,
            onTap: () {
              onSelected(index);
            },
          );
        },
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  const _DayItem({
    required this.food,
    required this.selected,
    required this.onTap,
  });

  final FoodEntity food;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dayNumber = _dayNumber(food.date);

    final foregroundColor = selected ? _foodOrange : _foodBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 190,
          ),
          curve: Curves.easeOutCubic,
          width: 68,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? _foodOrange.withValues(
                    alpha: 0.09,
                  )
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? _foodOrange
                  : _foodBlue.withValues(
                      alpha: 0.10,
                    ),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: _foodOrange.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 12,
                      offset: const Offset(
                        0,
                        4,
                      ),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.035,
                      ),
                      blurRadius: 8,
                      offset: const Offset(
                        0,
                        3,
                      ),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _shortDay(food.day),
                maxLines: 1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: foregroundColor.withValues(
                        alpha: 0.78,
                      ),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                dayNumber,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: foregroundColor,
                      fontSize: 17,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
              ),

              if (food.isHoliday) ...[
                const SizedBox(
                  height: 3,
                ),
                Icon(
                  Icons.event_busy_rounded,
                  size: 11,
                  color: selected ? _foodOrange : AppColors.error,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _dayNumber(String date) {
    final parsed = DateTime.tryParse(date);

    if (parsed == null) {
      return '-';
    }

    return parsed.day.toString();
  }

  String _shortDay(String day) {
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
      case 'Cumartesi':
        return 'Cmt';
      case 'Pazar':
        return 'Paz';
      default:
        return day;
    }
  }
}
