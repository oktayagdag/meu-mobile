import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/application/providers/ring_mock_provider.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_routes_list.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_tab_selector.dart';

class RingPage extends ConsumerWidget {
  const RingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedRingTabProvider);
    final visibleRoutes = ref.watch(visibleRingRoutesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ring Saatleri'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          children: [
            RingTabSelector(
              selectedTab: selectedTab,
              onSelected: (tab) {
                ref.read(selectedRingTabProvider.notifier).select(tab);
              },
            ),
            const Gap(AppSpacing.lg),
            RingRoutesList(routes: visibleRoutes),
          ],
        ),
      ),
    );
  }
}