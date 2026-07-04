import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    required this.name,
    super.key,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final firstName = name.split(' ').first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merhaba, $firstName 👋',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const Gap(AppSpacing.xs),
        Text(
          'Bugün kampüste neler var birlikte bakalım.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}