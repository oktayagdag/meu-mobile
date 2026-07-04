import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/domain/entities/food_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
              ),
              borderRadius: AppRadius.md,
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                Gap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Bu Hafta',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.md),
          Text(
            '28 Haziran - 4 Temmuz',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Gap(AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(foods.length, (index) {
              final food = foods[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == foods.length - 1 ? 0 : AppSpacing.xs,
                  ),
                  child: _DayChip(
                    label: _shortDay(food.day),
                    dayNumber: _dayNumber(food.date),
                    isSelected: isSelected,
                    onTap: () => onSelected(index),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
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
      default:
        return day.substring(0, 3);
    }
  }

  String _dayNumber(String date) {
    return date.split(' ').first;
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.dayNumber,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String dayNumber;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.md,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Gap(2),
            Text(
              dayNumber,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}