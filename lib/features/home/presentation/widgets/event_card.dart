import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.event_available_rounded, size: 32),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teknoloji Topluluğu Etkinliği', style: textTheme.titleMedium),
                const Gap(AppSpacing.sm),
                Text('Bugün • 14:00 • Konferans Salonu', style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}