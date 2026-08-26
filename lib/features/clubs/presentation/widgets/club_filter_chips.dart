import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/features/clubs/presentation/theme/club_design_tokens.dart';

class ClubFilterChips extends StatelessWidget {
  const ClubFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final StudentClubCategory selectedCategory;
  final ValueChanged<StudentClubCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = StudentClubCategory.values;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: AppSpacing.sm,
          );
        },
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              selectedCategory == category;
          final color = _categoryColor(category);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onSelected(category);
              },
              borderRadius: BorderRadius.circular(99),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.12)
                      : ClubDesignTokens.surface(context),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.46)
                        : ClubDesignTokens.border(context),
                    width: isSelected ? 1.25 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _categoryIcon(category),
                      color: isSelected
                          ? color
                          : ClubDesignTokens.secondaryText(
                              context,
                            ),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label,
                      style: TextStyle(
                        color: isSelected
                            ? color
                            : ClubDesignTokens.secondaryText(
                                context,
                              ),
                        fontSize: 11.5,
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _categoryIcon(
    StudentClubCategory category,
  ) {
    switch (category) {
      case StudentClubCategory.all:
        return Icons.apps_rounded;
      case StudentClubCategory.technology:
        return Icons.computer_rounded;
      case StudentClubCategory.culture:
        return Icons.palette_rounded;
      case StudentClubCategory.sport:
        return Icons.sports_basketball_rounded;
      case StudentClubCategory.social:
        return Icons.volunteer_activism_rounded;
      case StudentClubCategory.science:
        return Icons.science_rounded;
    }
  }

  Color _categoryColor(
    StudentClubCategory category,
  ) {
    switch (category) {
      case StudentClubCategory.all:
        return ClubDesignTokens.navy;
      case StudentClubCategory.technology:
        return ClubDesignTokens.purple;
      case StudentClubCategory.culture:
        return ClubDesignTokens.orange;
      case StudentClubCategory.sport:
        return ClubDesignTokens.green;
      case StudentClubCategory.social:
        return ClubDesignTokens.teal;
      case StudentClubCategory.science:
        return ClubDesignTokens.red;
    }
  }
}
