import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';

class CampusLocationFilterChips extends StatelessWidget {
  const CampusLocationFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final CampusLocationCategory selectedCategory;
  final ValueChanged<CampusLocationCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = CampusLocationCategory.values;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: AppSpacing.sm,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            label: Text(category.label),
            labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}