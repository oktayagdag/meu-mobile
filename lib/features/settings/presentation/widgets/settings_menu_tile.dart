import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';

class SettingsMenuTile extends StatelessWidget {
  const SettingsMenuTile({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: [
          AppIconContainer(
            icon: icon,
            iconColor: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.10),
            size: 44,
            iconSize: 22,
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(2),
                Text(
                  description,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
