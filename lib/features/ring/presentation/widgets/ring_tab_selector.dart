import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_mock_provider.dart';

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
      children: [
        _TabItem(
          title: 'Hatlar',
          selected: selectedTab == RingTab.routes,
          onTap: () => onSelected(RingTab.routes),
        ),
        _TabItem(
          title: 'Favorilerim',
          selected: selectedTab == RingTab.favorites,
          onTap: () => onSelected(RingTab.favorites),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: selected ? 72 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}