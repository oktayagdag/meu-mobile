import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/events/application/providers/events_mock_provider.dart';
import 'package:meu_mobile/features/events/presentation/widgets/event_filter_chips.dart';
import 'package:meu_mobile/features/events/presentation/widgets/event_list_card.dart';
import 'package:meu_mobile/shared/widgets/inputs/app_search_field.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedEventCategoryProvider);
    final events = ref.watch(filteredEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlikler'),
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
              hintText: 'Etkinlik ara...',
              onChanged: (value) {
                ref.read(eventSearchQueryProvider.notifier).update(value);
              },
            ),
            const Gap(AppSpacing.md),
            EventFilterChips(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                ref.read(selectedEventCategoryProvider.notifier).select(category);
              },
            ),
            const Gap(AppSpacing.lg),
            if (events.isEmpty)
              const EmptyState(
                title: 'Etkinlik bulunamadı',
                description: 'Aramana veya filtre seçimine uygun etkinlik yok.',
                icon: Icons.event_busy_rounded,
              )
            else
              Column(
                children: List.generate(events.length, (index) {
                  final event = events[index];

                  return Column(
                    children: [
                      EventListCard(
                        event: event,
                        onTap: () {
                          context.go('/events/${event.id}');
                        },
                      ),
                      if (index != events.length - 1)
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