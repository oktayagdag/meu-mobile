import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/clubs/application/providers/clubs_mock_provider.dart';
import 'package:meu_mobile/features/clubs/presentation/widgets/club_filter_chips.dart';
import 'package:meu_mobile/features/clubs/presentation/widgets/club_list_card.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class ClubsPage extends ConsumerWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedClubCategoryProvider);
    final clubs = ref.watch(filteredClubsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluklar'),
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
            AppSearchField(
              hintText: 'Topluluk ara...',
              onChanged: (value) {
                ref.read(clubSearchQueryProvider.notifier).update(value);
              },
            ),
            const Gap(AppSpacing.md),
            ClubFilterChips(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                ref.read(selectedClubCategoryProvider.notifier).select(category);
              },
            ),
            const Gap(AppSpacing.lg),
            if (clubs.isEmpty)
              const EmptyState(
                title: 'Topluluk bulunamadı',
                description: 'Aramana veya filtre seçimine uygun topluluk yok.',
                icon: Icons.groups_outlined,
              )
            else
              Column(
                children: List.generate(clubs.length, (index) {
                  final club = clubs[index];

                  return Column(
                    children: [
                      ClubListCard(
                        club: club,
                        onTap: () {
                          context.go('/clubs/${club.id}');
                        },
                      ),
                      if (index != clubs.length - 1)
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