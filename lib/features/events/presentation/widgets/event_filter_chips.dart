import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/events/presentation/theme/event_design_tokens.dart';

class EventFilterChips extends StatelessWidget {
  const EventFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final CampusEventCategory selectedCategory;
  final ValueChanged<CampusEventCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = CampusEventCategory.values;

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
                      : EventDesignTokens.surface(context),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.46)
                        : EventDesignTokens.border(context),
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
                          : EventDesignTokens.secondaryText(
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
                            : EventDesignTokens.secondaryText(
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
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return Icons.apps_rounded;
      case CampusEventCategory.conference:
        return Icons.mic_rounded;
      case CampusEventCategory.community:
        return Icons.groups_rounded;
      case CampusEventCategory.culture:
        return Icons.theater_comedy_rounded;
      case CampusEventCategory.sport:
        return Icons.sports_soccer_rounded;
    }
  }

  Color _categoryColor(
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return EventDesignTokens.navy;
      case CampusEventCategory.conference:
        return EventDesignTokens.purple;
      case CampusEventCategory.community:
        return EventDesignTokens.teal;
      case CampusEventCategory.culture:
        return EventDesignTokens.orange;
      case CampusEventCategory.sport:
        return EventDesignTokens.green;
    }
  }
}
