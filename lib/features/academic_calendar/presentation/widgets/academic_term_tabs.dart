import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/academic_calendar/domain/entities/academic_calendar_item_entity.dart';

class AcademicTermTabs extends StatelessWidget {
  const AcademicTermTabs({
    required this.selectedTerm,
    required this.onSelected,
    super.key,
  });

  final AcademicTerm selectedTerm;
  final ValueChanged<AcademicTerm> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lg,
      ),
      child: Row(
        children: [
          _TermTabButton(
            title: 'Güz Yarıyılı',
            selected: selectedTerm == AcademicTerm.fall,
            onTap: () => onSelected(AcademicTerm.fall),
          ),
          _TermTabButton(
            title: 'Bahar Yarıyılı',
            selected: selectedTerm == AcademicTerm.spring,
            onTap: () => onSelected(AcademicTerm.spring),
          ),
        ],
      ),
    );
  }
}

class _TermTabButton extends StatelessWidget {
  const _TermTabButton({
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
        borderRadius: AppRadius.md,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.md,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
