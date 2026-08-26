import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/announcements/application/providers/announcements_provider.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/announcements/presentation/theme/announcement_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class AnnouncementDetailPage extends ConsumerWidget {
  const AnnouncementDetailPage({
    required this.announcementId,
    super.key,
  });

  final String announcementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementAsync = ref.watch(
      announcementDetailProvider(
        announcementId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duyuru Detayı'),
      ),
      body: announcementAsync.when(
        loading: () {
          return const AppLoadingState(
            message: 'Duyuru yükleniyor...',
          );
        },
        error: (error, stackTrace) {
          return AppErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(
                announcementDetailProvider(
                  announcementId,
                ),
              );
            },
          );
        },
        data: (announcement) {
          if (announcement == null) {
            return const EmptyState(
              title: 'Duyuru bulunamadı',
              description:
                  'Bu duyuru kaldırılmış veya erişilemiyor olabilir.',
              icon: Icons.campaign_outlined,
            );
          }

          final categoryColor = _categoryColor(
            announcement.category,
          );

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _AnnouncementDetailHero(
                  category: announcement.category,
                  publishedAt: announcement.publishedAt,
                  title: announcement.title,
                  description: announcement.description,
                  categoryColor: categoryColor,
                  categoryIcon: _categoryIcon(
                    announcement.category,
                  ),
                ),
                const Gap(12),
                _AnnouncementContentCard(
                  content: announcement.content,
                  categoryColor: categoryColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _categoryIcon(
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return Icons.campaign_rounded;
      case AnnouncementCategory.academic:
        return Icons.school_rounded;
      case AnnouncementCategory.administrative:
        return Icons.account_balance_rounded;
      case AnnouncementCategory.event:
        return Icons.event_rounded;
    }
  }

  Color _categoryColor(
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return AnnouncementDesignTokens.navy;
      case AnnouncementCategory.academic:
        return AnnouncementDesignTokens.green;
      case AnnouncementCategory.administrative:
        return AnnouncementDesignTokens.purple;
      case AnnouncementCategory.event:
        return AnnouncementDesignTokens.orange;
    }
  }
}

class _AnnouncementDetailHero extends StatelessWidget {
  const _AnnouncementDetailHero({
    required this.category,
    required this.publishedAt,
    required this.title,
    required this.description,
    required this.categoryColor,
    required this.categoryIcon,
  });

  final AnnouncementCategory category;
  final String publishedAt;
  final String title;
  final String description;
  final Color categoryColor;
  final IconData categoryIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration:
          AnnouncementDesignTokens.surfaceDecoration(
        context,
        accent: categoryColor,
        radius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      categoryColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 25,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      text: category.label,
                      foregroundColor: categoryColor,
                      backgroundColor: categoryColor
                          .withValues(alpha: 0.11),
                    ),
                    const Gap(7),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: AnnouncementDesignTokens
                              .secondaryText(context),
                        ),
                        const Gap(5),
                        Expanded(
                          child: Text(
                            publishedAt,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  AnnouncementDesignTokens
                                      .secondaryText(
                                context,
                              ),
                              fontSize: 10.8,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(18),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  color:
                      AnnouncementDesignTokens.primaryText(
                    context,
                  ),
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
          ),
          const Gap(10),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color:
                      AnnouncementDesignTokens.secondaryText(
                    context,
                  ),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementContentCard
    extends StatelessWidget {
  const _AnnouncementContentCard({
    required this.content,
    required this.categoryColor,
  });

  final String content;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration:
          AnnouncementDesignTokens.surfaceDecoration(
        context,
        radius: 22,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius:
                      BorderRadius.circular(99),
                ),
              ),
              const Gap(9),
              Text(
                'Duyuru İçeriği',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color:
                          AnnouncementDesignTokens
                              .primaryText(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const Gap(14),
          Text(
            content,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(
                  color:
                      AnnouncementDesignTokens.primaryText(
                    context,
                  ),
                  fontSize: 14,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
