import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/event_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
  });

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.12),
              borderRadius: AppRadius.lg,
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: AppColors.secondary,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: textTheme.titleMedium),
                const Gap(AppSpacing.sm),
                Text(
                  '${event.date} • ${event.time} • ${event.location}',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}