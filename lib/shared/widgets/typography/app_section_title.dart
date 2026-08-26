import 'package:flutter/material.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    required this.title,
    super.key,
    this.actionText,
    this.onActionTap,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.titleMedium),
        if (actionText != null)
          TextButton(onPressed: onActionTap, child: Text(actionText!)),
      ],
    );
  }
}
