import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/campus_map/application/providers/campus_map_mock_provider.dart';
import 'package:meu_mobile/features/campus_map/presentation/widgets/campus_location_card.dart';
import 'package:meu_mobile/features/campus_map/presentation/widgets/campus_location_filter_chips.dart';
import 'package:meu_mobile/shared/utils/app_feedback.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class CampusMapPage extends ConsumerWidget {
  const CampusMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCampusLocationCategoryProvider);
    final locations = ref.watch(filteredCampusLocationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampüs Haritası'),
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
            const _CampusMapPreviewCard(),
            const Gap(AppSpacing.md),
            AppSearchField(
              hintText: 'Kampüste yer ara...',
              onChanged: (value) {
                ref.read(campusLocationSearchQueryProvider.notifier).update(value);
              },
            ),
            const Gap(AppSpacing.md),
            CampusLocationFilterChips(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                ref
                    .read(selectedCampusLocationCategoryProvider.notifier)
                    .select(category);
              },
            ),
            const Gap(AppSpacing.lg),
            if (locations.isEmpty)
              const EmptyState(
                title: 'Konum bulunamadı',
                description: 'Aramana veya filtre seçimine uygun kampüs konumu yok.',
                icon: Icons.map_outlined,
              )
            else
              Column(
                children: List.generate(locations.length, (index) {
                  return Column(
                    children: [
                      CampusLocationCard(
                        location: locations[index],
                        onTap: () {
                          showComingSoonSnackBar(
                            context,
                            featureName: 'Detaylı harita görünümü',
                          );
                        },
                      ),
                      if (index != locations.length - 1)
                        const Gap(AppSpacing.sm),
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _CampusMapPreviewCard extends StatelessWidget {
  const _CampusMapPreviewCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.92),
              AppColors.secondary.withValues(alpha: 0.92),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -24,
              child: Icon(
                Icons.map_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  const Spacer(),
                  Text(
                    'Çiftlikköy Kampüsü',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const Gap(AppSpacing.xs),
                  Text(
                    'Fakülte, yemekhane, ring durağı ve sosyal alanları keşfet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.90),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}