import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/food/application/providers/food_mock_provider.dart';
import 'package:meu_mobile/features/food/presentation/widgets/daily_food_card.dart';
import 'package:meu_mobile/features/food/presentation/widgets/weekly_food_list.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayFood = ref.watch(todayFoodProvider);
    final weeklyFoods = ref.watch(weeklyFoodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yemekhane'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DailyFoodCard(food: todayFood),
            const Gap(AppSpacing.lg),
            const AppSectionTitle(title: 'Haftalık Menü'),
            const Gap(AppSpacing.sm),
            WeeklyFoodList(
                foods: weeklyFoods,
                todayDay: todayFood.day,
            ),
          ],
        ),
      ),
    );
  }
}