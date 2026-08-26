import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/typography/app_section_title.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({
    required this.title,
    required this.child,
    super.key,
    this.actionText,
    this.onActionTap,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: title,
          actionText: actionText,
          onActionTap: onActionTap,
        ),
        const Gap(AppSpacing.sm),
        child,
      ],
    );
  }
}
