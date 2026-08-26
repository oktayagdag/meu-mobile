import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_provider.dart';

class RingTabSelector extends StatelessWidget {
  const RingTabSelector({
    required this.selectedTab,
    required this.onSelected,
    super.key,
  });

  final RingTab selectedTab;
  final ValueChanged<RingTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RingTab.values.map((tab) {
        final isSelected = selectedTab == tab;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: tab != RingTab.values.last ? 8 : 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                onSelected(tab);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tab.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
