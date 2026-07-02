import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: AppRadius.lg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lg,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}