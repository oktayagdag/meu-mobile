import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/core/cache/cache_keys.dart';
import 'package:meu_mobile/features/clubs/application/providers/clubs_provider.dart';
import 'package:meu_mobile/features/clubs/presentation/theme/club_design_tokens.dart';
import 'package:meu_mobile/features/clubs/presentation/widgets/club_filter_chips.dart';
import 'package:meu_mobile/features/clubs/presentation/widgets/club_list_card.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/cache_last_updated_text.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class ClubsPage extends ConsumerWidget {
  const ClubsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedClubCategoryProvider);
    final clubsAsync = ref.watch(filteredClubsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Topluluklar')),
      body: RefreshIndicator(
        color: ClubDesignTokens.orange,
        onRefresh: () async {
          ref.invalidate(clubsProvider);
          ref.invalidate(filteredClubsProvider);

          await ref.read(clubsProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            _ClubSearchField(
              onChanged: (value) {
                ref.read(clubSearchQueryProvider.notifier).update(value);
              },
            ),
            const Gap(12),
            ClubFilterChips(
              selectedCategory: selectedCategory,
              onSelected: (category) {
                ref
                    .read(selectedClubCategoryProvider.notifier)
                    .select(category);
              },
            ),
            const Gap(10),
            const Align(
              alignment: Alignment.centerRight,
              child: CacheLastUpdatedText(cacheKey: CacheKeys.clubs),
            ),
            const Gap(AppSpacing.md),
            clubsAsync.when(
              loading: () {
                return const AppLoadingState(
                  message: 'Topluluklar yükleniyor...',
                );
              },
              error: (error, stackTrace) {
                return AppErrorState(
                  error: error,
                  onRetry: () {
                    ref.invalidate(clubsProvider);
                    ref.invalidate(filteredClubsProvider);
                  },
                );
              },
              data: (clubs) {
                if (clubs.isEmpty) {
                  return const EmptyState(
                    title: 'Topluluk bulunamadı',
                    description:
                        'Aramana veya seçtiğin kategoriye uygun '
                        'bir topluluk bulunamadı.',
                    icon: Icons.search_off_rounded,
                  );
                }

                return Column(
                  children: List.generate(clubs.length, (index) {
                    final club = clubs[index];

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == clubs.length - 1 ? 0 : 10,
                      ),
                      child: ClubListCard(
                        club: club,
                        onTap: () {
                          context.go('/clubs/${club.id}');
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
    );
  }
}

class _ClubSearchField extends StatelessWidget {
  const _ClubSearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : ClubDesignTokens.textPrimary;

    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : ClubDesignTokens.textSecondary;

    return Container(
      height: 52,
      decoration: ClubDesignTokens.surfaceDecoration(context, radius: 17),
      child: TextField(
        onChanged: onChanged,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        cursorColor: ClubDesignTokens.orange,
        style: TextStyle(
          color: textColor,
          fontSize: 13.5,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Topluluklarda ara',
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
                color: ClubDesignTokens.orange.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: ClubDesignTokens.orange,
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
