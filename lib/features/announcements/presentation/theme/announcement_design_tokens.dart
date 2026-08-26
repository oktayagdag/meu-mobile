import 'package:flutter/material.dart';

final class AnnouncementDesignTokens {
  const AnnouncementDesignTokens._();

  static const navy = Color(0xFF182958);
  static const deepNavy = Color(0xFF0D1735);
  static const orange = Color(0xFFF1743A);
  static const purple = Color(0xFF7C64D5);
  static const green = Color(0xFF2E9D57);
  static const teal = Color(0xFF008C95);
  static const textPrimary = Color(0xFF161A24);
  static const textSecondary = Color(0xFF667085);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color primaryText(BuildContext context) {
    return isDark(context) ? Colors.white : textPrimary;
  }

  static Color secondaryText(BuildContext context) {
    return isDark(context)
        ? Colors.white.withValues(alpha: 0.62)
        : textSecondary;
  }

  static Color border(BuildContext context) {
    return isDark(context)
        ? Colors.white.withValues(alpha: 0.07)
        : navy.withValues(alpha: 0.07);
  }

  static BoxDecoration surfaceDecoration(
    BuildContext context, {
    double radius = 20,
    Color? accent,
  }) {
    return BoxDecoration(
      color: surface(context),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: accent?.withValues(alpha: 0.20) ?? border(context),
      ),
      boxShadow: [
        BoxShadow(
          color: (accent ?? Colors.black).withValues(
            alpha: accent == null
                ? (isDark(context) ? 0.12 : 0.035)
                : (isDark(context) ? 0.10 : 0.055),
          ),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
