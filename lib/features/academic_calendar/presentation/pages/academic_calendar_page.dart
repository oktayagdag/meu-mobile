import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/academic_calendar/application/providers/academic_calendar_mock_provider.dart';
import 'package:meu_mobile/features/academic_calendar/domain/entities/academic_calendar_item_entity.dart';
import 'package:meu_mobile/features/academic_calendar/presentation/widgets/academic_calendar_item_card.dart';
import 'package:meu_mobile/features/academic_calendar/presentation/widgets/academic_term_tabs.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class AcademicCalendarPage extends ConsumerWidget {
  const AcademicCalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTerm = ref.watch(selectedAcademicTermProvider);
    final items = ref.watch(selectedAcademicCalendarItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akademik Takvim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AcademicCalendarHero(),
            const Gap(AppSpacing.md),
            AcademicTermTabs(
              selectedTerm: selectedTerm,
              onSelected: (term) {
                ref.read(selectedAcademicTermProvider.notifier).select(term);
              },
            ),
            const Gap(AppSpacing.md),
            _TermTitleCard(term: selectedTerm),
            const Gap(AppSpacing.md),
            AcademicCalendarTable(items: items),
            const Gap(AppSpacing.md),
            const _AcademicCalendarNote(),
          ],
        ),
      ),
    );
  }
}

class _AcademicCalendarHero extends StatelessWidget {
  const _AcademicCalendarHero();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary.withValues(alpha: 0.92),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -22,
              child: Icon(
                Icons.calendar_month_rounded,
                size: 128,
                color: Colors.white.withValues(alpha: 0.13),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2026-2027',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.90),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  'Eğitim-Öğretim Yılı',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Gap(AppSpacing.xs),
                Text(
                  'Güz ve bahar yarıyılı akademik tarihleri',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TermTitleCard extends StatelessWidget {
  const _TermTitleCard({
    required this.term,
  });

  final AcademicTerm term;

  @override
  Widget build(BuildContext context) {
    final isFall = term == AcademicTerm.fall;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isFall
            ? AppColors.warning.withValues(alpha: 0.12)
            : AppColors.secondary.withValues(alpha: 0.12),
        borderRadius: AppRadius.md,
      ),
      child: Text(
        isFall ? 'Güz Yarıyılı' : 'Bahar Yarıyılı',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isFall ? AppColors.warning : AppColors.secondary,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _AcademicCalendarNote extends StatelessWidget {
  const _AcademicCalendarNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Not: Bu takvim; Enstitüler, Tıp Fakültesi, Diş Hekimliği Fakültesi, '
      'Mersin Meslek Yüksekokulu ve Yabancı Diller Yüksekokulu Hazırlık Sınıfı '
      'öğrencileri haricindeki yarıyıllık ön lisans ve lisans programlarını kapsar.',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}