import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/academic_calendar/domain/entities/academic_calendar_item_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class AcademicCalendarTable extends StatelessWidget {
  const AcademicCalendarTable({required this.items, super.key});

  final List<AcademicCalendarItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const _TableHeader(),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;

            return Column(
              children: [
                _CalendarTableRow(item: item),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: AppSpacing.md,
                    endIndent: AppSpacing.md,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.cardValue),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              'Etkinlik',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Başlangıç',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Bitiş',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarTableRow extends StatelessWidget {
  const _CalendarTableRow({required this.item});

  final AcademicCalendarItemEntity item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              item.title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Gap(AppSpacing.sm),
          Expanded(flex: 2, child: _DatePill(text: item.startDate)),
          const Gap(AppSpacing.sm),
          Expanded(flex: 2, child: _DatePill(text: item.endDate)),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.sm,
        border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
