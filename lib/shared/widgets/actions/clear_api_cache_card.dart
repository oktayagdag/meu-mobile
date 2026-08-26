import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/providers/app_cache_actions_provider.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class ClearApiCacheCard extends ConsumerWidget {
  const ClearApiCacheCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      onTap: () {
        _showClearCacheDialog(context, ref);
      },
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.10),
              borderRadius: AppRadius.md,
            ),
            child: const Icon(
              Icons.delete_sweep_rounded,
              color: AppColors.error,
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Önbelleği Temizle',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900),
                ),
                const Gap(3),
                Text(
                  'Kaydedilmiş API verilerini ve son güncelleme bilgilerini sil.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Future<void> _showClearCacheDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Önbelleği temizle?'),
          content: const Text(
            'Duyurular, yemekhane, ring, etkinlikler, topluluklar ve kampüs haritası için kaydedilmiş offline veriler silinecek.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Temizle'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref.read(appCacheActionsProvider).clearApiCache();

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Önbellek temizlendi.')));
  }
}
