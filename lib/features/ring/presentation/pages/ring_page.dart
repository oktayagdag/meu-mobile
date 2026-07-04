import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_mock_provider.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/next_ring_summary_card.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_filter_chips.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_schedule_list.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class RingPage extends ConsumerWidget {
  const RingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(ringRoutesProvider);
    final nextRing = ref.watch(nextRingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ring Saatleri'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NextRingSummaryCard(ring: nextRing),
            const Gap(AppSpacing.lg),
            const AppSectionTitle(title: 'Hat Seçimi'),
            const Gap(AppSpacing.sm),
            const RingFilterChips(),
            const Gap(AppSpacing.lg),
            const AppSectionTitle(title: 'Bugünkü Saatler'),
            const Gap(AppSpacing.sm),
            RingScheduleList(routes: routes),
          ],
        ),
      ),
    );
  }
}