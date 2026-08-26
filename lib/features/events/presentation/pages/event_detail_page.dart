import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/events/application/providers/events_provider.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/events/presentation/theme/event_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(
      eventDetailProvider(eventId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Detayı'),
      ),
      body: eventAsync.when(
        loading: () {
          return const AppLoadingState(
            message: 'Etkinlik yükleniyor...',
          );
        },
        error: (error, stackTrace) {
          return AppErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(
                eventDetailProvider(eventId),
              );
            },
          );
        },
        data: (event) {
          if (event == null) {
            return const EmptyState(
              title: 'Etkinlik bulunamadı',
              description:
                  'Bu etkinlik kaldırılmış veya erişilemiyor olabilir.',
              icon: Icons.event_busy_rounded,
            );
          }

          final categoryColor = _categoryColor(
            event.category,
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
                _EventDetailHero(
                  category: event.category,
                  organizer: event.organizer,
                  title: event.title,
                  description: event.description,
                  categoryColor: categoryColor,
                  categoryIcon: _categoryIcon(
                    event.category,
                  ),
                ),
                const Gap(12),
                _EventInformationCard(
                  date: event.date,
                  time: event.time,
                  location: event.location,
                  organizer: event.organizer,
                  accentColor: categoryColor,
                ),
                const Gap(12),
                _EventContentCard(
                  content: event.content,
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
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return Icons.event_rounded;
      case CampusEventCategory.conference:
        return Icons.mic_rounded;
      case CampusEventCategory.community:
        return Icons.groups_rounded;
      case CampusEventCategory.culture:
        return Icons.theater_comedy_rounded;
      case CampusEventCategory.sport:
        return Icons.sports_soccer_rounded;
    }
  }

  Color _categoryColor(
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return EventDesignTokens.navy;
      case CampusEventCategory.conference:
        return EventDesignTokens.purple;
      case CampusEventCategory.community:
        return EventDesignTokens.teal;
      case CampusEventCategory.culture:
        return EventDesignTokens.orange;
      case CampusEventCategory.sport:
        return EventDesignTokens.green;
    }
  }
}

class _EventDetailHero extends StatelessWidget {
  const _EventDetailHero({
    required this.category,
    required this.organizer,
    required this.title,
    required this.description,
    required this.categoryColor,
    required this.categoryIcon,
  });

  final CampusEventCategory category;
  final String organizer;
  final String title;
  final String description;
  final Color categoryColor;
  final IconData categoryIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: EventDesignTokens.surfaceDecoration(
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
                          Icons.account_balance_rounded,
                          size: 13,
                          color:
                              EventDesignTokens.secondaryText(
                            context,
                          ),
                        ),
                        const Gap(5),
                        Expanded(
                          child: Text(
                            organizer,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  EventDesignTokens.secondaryText(
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
                  color: EventDesignTokens.primaryText(
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
                  color: EventDesignTokens.secondaryText(
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

class _EventInformationCard extends StatelessWidget {
  const _EventInformationCard({
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.accentColor,
  });

  final String date;
  final String time;
  final String location;
  final String organizer;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: EventDesignTokens.surfaceDecoration(
        context,
        radius: 22,
      ),
      child: Column(
        children: [
          _DetailInfoRow(
            icon: Icons.calendar_month_rounded,
            title: 'Tarih',
            value: date,
            color: accentColor,
          ),
          _InfoDivider(color: accentColor),
          _DetailInfoRow(
            icon: Icons.schedule_rounded,
            title: 'Saat',
            value: time,
            color: accentColor,
          ),
          _InfoDivider(color: accentColor),
          _DetailInfoRow(
            icon: Icons.location_on_rounded,
            title: 'Konum',
            value: location,
            color: accentColor,
          ),
          _InfoDivider(color: accentColor),
          _DetailInfoRow(
            icon: Icons.account_balance_rounded,
            title: 'Düzenleyen',
            value: organizer,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 21,
      thickness: 1,
      indent: 54,
      color: color.withValues(alpha: 0.10),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color:
                      EventDesignTokens.secondaryText(
                    context,
                  ),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(3),
              Text(
                value,
                style: TextStyle(
                  color: EventDesignTokens.primaryText(
                    context,
                  ),
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventContentCard extends StatelessWidget {
  const _EventContentCard({
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
      decoration: EventDesignTokens.surfaceDecoration(
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
                'Etkinlik İçeriği',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color: EventDesignTokens.primaryText(
                        context,
                      ),
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
                  color: EventDesignTokens.primaryText(
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
