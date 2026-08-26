import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/features/food/application/providers/food_provider.dart';
import 'package:meu_mobile/features/food/presentation/widgets/food_selector_card.dart';
import 'package:meu_mobile/features/food/presentation/widgets/selected_day_menu_card.dart';
import 'package:meu_mobile/features/home/application/providers/home_resources_provider.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/cache_last_updated_text.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodPage extends ConsumerWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyFoodsAsync = ref.watch(weeklyFoodProvider);
    final selectedIndex = ref.watch(selectedFoodIndexProvider);

    final homeResourcesAsync = ref.watch(homeResourcesProvider);
    final homeResources = homeResourcesAsync.asData?.value;

    String? balanceLoadUrl;

    if (homeResources != null) {
      for (final action in homeResources.quickActions) {
        final normalizedTitle = action.title.toLowerCase();

        if (normalizedTitle.contains('bakiye')) {
          balanceLoadUrl = action.url;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Yemekhane')),
      body: weeklyFoodsAsync.when(
        loading: () =>
            const AppLoadingState(message: 'Yemekhane menüsü yükleniyor...'),
        error: (error, stackTrace) => AppErrorState(
          error: error,
          onRetry: () {
            ref.read(selectedFoodIndexProvider.notifier).reset();
            ref.invalidate(weeklyFoodProvider);
            ref.invalidate(todayFoodProvider);
          },
        ),
        data: (weeklyFoods) {
          if (weeklyFoods.isEmpty) {
            return const EmptyState(
              title: 'Menü bulunamadı',
              description: 'Bu hafta için yemekhane menüsü bulunmuyor.',
              icon: Icons.restaurant_menu_rounded,
            );
          }

          final today = _todayKey();

          final todayIndex = weeklyFoods.indexWhere(
            (food) => food.date == today,
          );

          final defaultIndex = todayIndex >= 0 ? todayIndex : 0;

          final safeIndex =
              selectedIndex >= 0 && selectedIndex < weeklyFoods.length
              ? selectedIndex
              : defaultIndex;

          final selectedFood = weeklyFoods[safeIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (balanceLoadUrl != null) ...[
                  _BalanceLoadCard(url: balanceLoadUrl),
                  const Gap(AppSpacing.md),
                ],

                FoodSelectorCard(
                  foods: weeklyFoods,
                  selectedIndex: safeIndex,
                  onSelected: (index) {
                    ref.read(selectedFoodIndexProvider.notifier).select(index);
                  },
                ),

                const Gap(AppSpacing.sm),

                const CacheLastUpdatedText(cacheKey: CacheKeys.weeklyFoods),

                const Gap(AppSpacing.md),

                SelectedDayMenuCard(food: selectedFood),
              ],
            ),
          );
        },
      ),
    );
  }

  String _todayKey() {
    final now = DateTime.now();

    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

class _BalanceLoadCard extends StatelessWidget {
  const _BalanceLoadCard({required this.url});

  final String url;

  Future<void> _openBalancePage(BuildContext context) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showError(context);
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && context.mounted) {
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bakiye yükleme sayfası açılamadı.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        _openBalancePage(context);
      },
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bakiye Yükle',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(3),
                Text(
                  'Yemekhane bakiyeni E-Kampüs üzerinden yükle.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
