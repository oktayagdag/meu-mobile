import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/announcements/presentation/theme/announcement_design_tokens.dart';

class AnnouncementFilterChips extends StatelessWidget {
  const AnnouncementFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final AnnouncementCategory selectedCategory;
  final ValueChanged<AnnouncementCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = AnnouncementCategory.values;

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
                duration:
                    const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.12)
                      : AnnouncementDesignTokens.surface(
                          context,
                        ),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.46)
                        : AnnouncementDesignTokens.border(
                            context,
                          ),
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
                          : AnnouncementDesignTokens
                              .secondaryText(context),
                      size: 15,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      category.label,
                      style: TextStyle(
                        color: isSelected
                            ? color
                            : AnnouncementDesignTokens
                                .secondaryText(context),
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
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return Icons.apps_rounded;
      case AnnouncementCategory.academic:
        return Icons.school_rounded;
      case AnnouncementCategory.administrative:
        return Icons.account_balance_rounded;
      case AnnouncementCategory.event:
        return Icons.event_rounded;
    }
  }

  Color _categoryColor(
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return AnnouncementDesignTokens.navy;
      case AnnouncementCategory.academic:
        return AnnouncementDesignTokens.green;
      case AnnouncementCategory.administrative:
        return AnnouncementDesignTokens.purple;
      case AnnouncementCategory.event:
        return AnnouncementDesignTokens.orange;
    }
  }
}
