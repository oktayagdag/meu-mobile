import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('2026 Yaz Okulu Başvuruları', style: textTheme.titleMedium),
          const Gap(AppSpacing.sm),
          Text(
            'Yaz okulu başvuru tarihleri ve detayları yayınlandı.',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}