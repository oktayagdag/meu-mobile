import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_typography.dart';

final class AppTheme {
  const AppTheme._();

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color surfaceOf(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color primaryTextOf(BuildContext context) {
    return isDark(context) ? Colors.white : AppColors.textPrimary;
  }

  static Color secondaryTextOf(BuildContext context) {
    return isDark(context)
        ? Colors.white.withValues(alpha: 0.62)
        : AppColors.textSecondary;
  }

  static Color borderOf(BuildContext context) {
    return isDark(context)
        ? Colors.white.withValues(alpha: 0.07)
        : AppColors.primary.withValues(alpha: 0.07);
  }

  static BoxDecoration surfaceDecoration(
    BuildContext context, {
    double radius = AppRadius.cardValue,
    Color? accent,
  }) {
    return BoxDecoration(
      color: surfaceOf(context),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: accent?.withValues(alpha: 0.20) ?? borderOf(context),
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

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondary,
        selectionColor: AppColors.secondary.withValues(alpha: 0.22),
        selectionHandleColor: AppColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return TextStyle(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected
                ? FontWeight.w800
                : FontWeight.w600,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.4,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.07),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.28);
          }

          return AppColors.textSecondary.withValues(alpha: 0.18);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.primary.withValues(alpha: 0.08),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.secondary,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondary,
        selectionColor: AppColors.secondary.withValues(alpha: 0.26),
        selectionHandleColor: AppColors.secondary,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.secondary.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);

          return TextStyle(
            color: isSelected
                ? AppColors.secondary
                : Colors.white70,
            fontSize: 12,
            fontWeight: isSelected
                ? FontWeight.w800
                : FontWeight.w600,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: const TextStyle(
          color: Colors.white60,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: const BorderSide(
            color: AppColors.secondary,
            width: 1.4,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.primary.withValues(alpha: 0.22),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary;
          }

          return Colors.white70;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.secondary.withValues(alpha: 0.30);
          }

          return Colors.white24;
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.08),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.secondary,
      ),
    );
  }
}
