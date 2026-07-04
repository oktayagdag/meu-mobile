import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    required this.items,
    super.key,
  });

  final List<QuickActionEntity> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisExtent: 92,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return AppCard(
          onTap: () {
            context.go(item.route);
          },
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _backgroundColor(index),
                  borderRadius: AppRadius.md,
                ),
                child: Icon(
                  item.icon,
                  color: _iconColor(index),
                  size: 23,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _iconColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.success,
      AppColors.error,
      AppColors.primary,
    ];

    return colors[index % colors.length];
  }

  Color _backgroundColor(int index) {
    return _iconColor(index).withValues(alpha: 0.10);
  }
}