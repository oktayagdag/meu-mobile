import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_provider.dart';
import 'package:meu_mobile/features/announcements/presentation/theme/announcement_design_tokens.dart';
import 'package:meu_mobile/features/announcements/presentation/widgets/announcement_filter_chips.dart';
import 'package:meu_mobile/features/announcements/presentation/widgets/announcement_list_card.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/cache_last_updated_text.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedAnnouncementCategoryProvider);
    final announcementsAsync = ref.watch(filteredAnnouncementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Duyurular')),
      body: RefreshIndicator(
        color: AnnouncementDesignTokens.orange,
        onRefresh: () async {
          ref.invalidate(announcementsProvider);
          ref.invalidate(filteredAnnouncementsProvider);

          await ref.read(filteredAnnouncementsProvider.future);
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
              _AnnouncementSearchField(
                onChanged: (value) {
                  ref
                      .read(announcementSearchQueryProvider.notifier)
                      .update(value);
                },
              ),
              const Gap(12),
              AnnouncementFilterChips(
                selectedCategory: selectedCategory,
                onSelected: (category) {
                  ref
                      .read(selectedAnnouncementCategoryProvider.notifier)
                      .select(category);
                },
              ),
              const Gap(10),
              const Align(
                alignment: Alignment.centerRight,
                child: CacheLastUpdatedText(cacheKey: CacheKeys.announcements),
              ),
              const Gap(AppSpacing.md),
              announcementsAsync.when(
                loading: () {
                  return const AppLoadingState(
                    message: 'Duyurular yükleniyor...',
                  );
                },
                error: (error, stackTrace) {
                  return AppErrorState(
                    error: error,
                    onRetry: () {
                      ref.invalidate(announcementsProvider);
                      ref.invalidate(filteredAnnouncementsProvider);
                    },
                  );
                },
                data: (announcements) {
                  if (announcements.isEmpty) {
                    return const EmptyState(
                      title: 'Duyuru bulunamadı',
                      description: 'Seçili filtrelere uygun duyuru bulunmuyor.',
                      icon: Icons.campaign_rounded,
                    );
                  }

                  return Column(
                    children: List.generate(announcements.length, (index) {
                      final announcement = announcements[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == announcements.length - 1 ? 0 : 10,
                        ),
                        child: AnnouncementListCard(
                          announcement: announcement,
                          onTap: () {
                            context.go('/announcements/${announcement.id}');
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

class _AnnouncementSearchField extends StatelessWidget {
  const _AnnouncementSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Colors.white
        : AnnouncementDesignTokens.textPrimary;

    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : AnnouncementDesignTokens.textSecondary;

    return Container(
      height: 52,
      decoration: AnnouncementDesignTokens.surfaceDecoration(
        context,
        radius: 17,
      ),
      child: TextField(
        onChanged: onChanged,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        cursorColor: AnnouncementDesignTokens.orange,
        style: TextStyle(
          color: textColor,
          fontSize: 13.5,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Duyurularda ara',
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
                color: AnnouncementDesignTokens.orange.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AnnouncementDesignTokens.orange,
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
