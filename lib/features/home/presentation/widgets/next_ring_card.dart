import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class NextRingCard extends StatelessWidget {
  const NextRingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        children: [
          const Icon(Icons.directions_bus_rounded, size: 32),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sonraki Ring', style: textTheme.titleMedium),
                const Gap(AppSpacing.sm),
                Text('Mühendislik → Çiftlikköy', style: textTheme.bodyMedium),
              ],
            ),
          ),
          Text('12 dk', style: textTheme.titleLarge),
        ],
      ),
    );
  }
}