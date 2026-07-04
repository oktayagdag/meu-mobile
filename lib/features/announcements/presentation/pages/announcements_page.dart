import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_mock_provider.dart';
import 'package:meu_mobile/features/announcements/presentation/widgets/announcement_filter_chips.dart';
import 'package:meu_mobile/features/announcements/presentation/widgets/announcement_list_card.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:go_router/go_router.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedAnnouncementCategoryProvider);
    final announcements = ref.watch(filteredAnnouncementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Duyurular')),
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
              hintText: 'Duyuru ara...',
              onChanged: (value) {
                ref
                    .read(announcementSearchQueryProvider.notifier)
                    .update(value);
              },
            ),
            const Gap(AppSpacing.md),
            AnnouncementFilterChips(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                ref
                    .read(selectedAnnouncementCategoryProvider.notifier)
                    .select(category);
              },
            ),
            const Gap(AppSpacing.lg),
            if (announcements.isEmpty)
              const EmptyState(
                title: 'Duyuru bulunamadı',
                description: 'Aramana veya filtre seçimine uygun duyuru yok.',
                icon: Icons.campaign_outlined,
              )
            else
              Column(
                children: List.generate(announcements.length, (index) {
                  return Column(
                    children: [
                      AnnouncementListCard(
                        announcement: announcements[index],
                        onTap: () {
                          context.go(
                            '/announcements/${announcements[index].id}',
                          );
                        },
                      ),
                      if (index != announcements.length - 1)
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
