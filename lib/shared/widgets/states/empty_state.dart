import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.description,
    super.key,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const Gap(AppSpacing.md),
            Text(title, style: textTheme.titleMedium),
            const Gap(AppSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
