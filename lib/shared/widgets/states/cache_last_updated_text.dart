import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';

class CacheLastUpdatedText extends StatelessWidget {
  const CacheLastUpdatedText({
    required this.cacheKey,
    this.prefix = 'Son güncelleme',
    super.key,
  });

  final String cacheKey;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<String>>(
      valueListenable: Hive.box<String>(
        ApiCacheService.boxName,
      ).listenable(keys: [cacheKey]),
      builder: (context, box, child) {
        final cacheService = ApiCacheService(box);
        final savedAt = cacheService.readSavedAt(cacheKey);

        if (savedAt == null) {
          return const SizedBox.shrink();
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                '$prefix: ${_formatDateTime(savedAt)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDateTime(DateTime value) {
    final localValue = value.toLocal();
    final now = DateTime.now();

    final isToday =
        localValue.year == now.year &&
        localValue.month == now.month &&
        localValue.day == now.day;

    final hour = localValue.hour.toString().padLeft(2, '0');
    final minute = localValue.minute.toString().padLeft(2, '0');

    if (isToday) {
      return 'Bugün $hour:$minute';
    }

    final day = localValue.day.toString().padLeft(2, '0');
    final month = localValue.month.toString().padLeft(2, '0');
    final year = localValue.year.toString();

    return '$day.$month.$year $hour:$minute';
  }
}
