import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/features/events/application/providers/events_provider.dart';
import 'package:meu_mobile/features/events/presentation/theme/event_design_tokens.dart';
import 'package:meu_mobile/features/events/presentation/widgets/event_filter_chips.dart';
import 'package:meu_mobile/features/events/presentation/widgets/event_list_card.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/cache_last_updated_text.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedEventCategoryProvider);
    final eventsAsync = ref.watch(filteredEventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Etkinlikler')),
      body: RefreshIndicator(
        color: EventDesignTokens.orange,
        onRefresh: () async {
          ref.invalidate(eventsProvider);
          ref.invalidate(filteredEventsProvider);

          await ref.read(filteredEventsProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventSearchField(
                onChanged: (value) {
                  ref.read(eventSearchQueryProvider.notifier).update(value);
                },
              ),
              const Gap(12),
              EventFilterChips(
                selectedCategory: selectedCategory,
                onSelected: (category) {
                  ref
                      .read(selectedEventCategoryProvider.notifier)
                      .select(category);
                },
              ),
              const Gap(10),
              const Align(
                alignment: Alignment.centerRight,
                child: CacheLastUpdatedText(cacheKey: CacheKeys.events),
              ),
              const Gap(AppSpacing.md),
              eventsAsync.when(
                loading: () {
                  return const AppLoadingState(
                    message: 'Etkinlikler yükleniyor...',
                  );
                },
                error: (error, stackTrace) {
                  return AppErrorState(
                    error: error,
                    onRetry: () {
                      ref.invalidate(eventsProvider);
                      ref.invalidate(filteredEventsProvider);
                    },
                  );
                },
                data: (events) {
                  if (events.isEmpty) {
                    return const EmptyState(
                      title: 'Etkinlik bulunamadı',
                      description:
                          'Seçili filtrelere uygun etkinlik bulunmuyor.',
                      icon: Icons.event_busy_rounded,
                    );
                  }

                  return Column(
                    children: List.generate(events.length, (index) {
                      final event = events[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == events.length - 1 ? 0 : 10,
                        ),
                        child: EventListCard(
                          event: event,
                          onTap: () {
                            context.go('/events/${event.id}');
                          },
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventSearchField extends StatelessWidget {
  const _EventSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : EventDesignTokens.textPrimary;

    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : EventDesignTokens.textSecondary;

    return Container(
      height: 52,
      decoration: EventDesignTokens.surfaceDecoration(context, radius: 17),
      child: TextField(
        onChanged: onChanged,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        cursorColor: EventDesignTokens.orange,
        style: TextStyle(
          color: textColor,
          fontSize: 13.5,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Etkinliklerde ara',
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 52,
            maxWidth: 52,
            minHeight: 52,
            maxHeight: 52,
          ),
          prefixIcon: Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: EventDesignTokens.orange.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: EventDesignTokens.orange,
                size: 20,
              ),
            ),
          ),
          isDense: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.only(left: 2, right: 14),
        ),
      ),
    );
  }
}
