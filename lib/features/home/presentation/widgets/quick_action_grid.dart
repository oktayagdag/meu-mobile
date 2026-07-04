import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/quick_action_entity.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    required this.actions,
    required this.onActionTap,
    super.key,
  });

  final List<QuickActionEntity> actions;
  final ValueChanged<String> onActionTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: actions.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.sm),
          onTap: () => onActionTap(action.route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                color: AppColors.primary,
                size: 28,
              ),
              const Gap(AppSpacing.sm),
              Text(
                action.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}