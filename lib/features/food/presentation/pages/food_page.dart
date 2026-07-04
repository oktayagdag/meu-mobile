import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/application/providers/food_mock_provider.dart';
import 'package:meu_mobile/features/food/presentation/widgets/food_selector_card.dart';
import 'package:meu_mobile/features/food/presentation/widgets/selected_day_menu_card.dart';

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyFoods = ref.watch(weeklyFoodProvider);
    final selectedFood = ref.watch(selectedFoodProvider);
    final selectedIndex = ref.watch(selectedFoodIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemekhane'),
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
            FoodSelectorCard(
              foods: weeklyFoods,
              selectedIndex: selectedIndex,
              onSelected: (index) {
                ref.read(selectedFoodIndexProvider.notifier).select(index);
              },
            ),
            const Gap(AppSpacing.md),
            SelectedDayMenuCard(food: selectedFood),
          ],
        ),
      ),
    );
  }
}