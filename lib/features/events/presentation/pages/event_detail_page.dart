import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/events/application/providers/events_mock_provider.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({
    required this.eventId,
    super.key,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);

    CampusEventEntity? event;

    for (final item in events) {
      if (item.id == eventId) {
        event = item;
        break;
      }
    }

    if (event == null) {
      return const Scaffold(
        body: EmptyState(
          title: 'Etkinlik bulunamadı',
          description: 'Açmak istediğin etkinlik kaldırılmış veya güncellenmiş olabilir.',
          icon: Icons.event_busy_rounded,
        ),
      );
    }

    final categoryColor = _categoryColor(event.category);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Detayı'),
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
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIconContainer(
                        icon: _categoryIcon(event.category),
                        iconColor: categoryColor,
                        backgroundColor: categoryColor.withValues(alpha: 0.12),
                        size: 52,
                        iconSize: 28,
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: [
                            StatusBadge(
                              text: event.category.label,
                              foregroundColor: categoryColor,
                              backgroundColor:
                                  categoryColor.withValues(alpha: 0.12),
                            ),
                            StatusBadge(
                              text: event.date,
                              foregroundColor: AppColors.primary,
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.10),
                            ),
                            StatusBadge(
                              text: event.time,
                              foregroundColor: AppColors.success,
                              backgroundColor:
                                  AppColors.success.withValues(alpha: 0.12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    event.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    event.description,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    title: 'Konum',
                    value: event.location,
                  ),
                  const Gap(AppSpacing.md),
                  _InfoRow(
                    icon: Icons.groups_rounded,
                    title: 'Düzenleyen',
                    value: event.organizer,
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            AppCard(
              child: Text(
                event.content,
                style: textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(CampusEventCategory category) {
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

  Color _categoryColor(CampusEventCategory category) {
    switch (category) {
      case CampusEventCategory.all:
        return AppColors.primary;
      case CampusEventCategory.conference:
        return AppColors.primary;
      case CampusEventCategory.community:
        return AppColors.secondary;
      case CampusEventCategory.culture:
        return AppColors.warning;
      case CampusEventCategory.sport:
        return AppColors.success;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
        const Gap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}