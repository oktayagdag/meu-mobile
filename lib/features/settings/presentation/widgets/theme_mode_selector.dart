import 'package:flutter/material.dart';
import 'package:meu_mobile/features/settings/domain/entities/app_settings.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final AppThemePreference value;
  final ValueChanged<AppThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: AppThemePreference.values.map(
          (preference) {
            final selected = preference == value;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: preference !=
                          AppThemePreference.values.last
                      ? 7
                      : 0,
                ),
                child: _ThemeOption(
                  preference: preference,
                  selected: selected,
                  onTap: () {
                    onChanged(preference);
                  },
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.preference,
    required this.selected,
    required this.onTap,
  });

  static const _navy = Color(0xFF182958);
  static const _orange = Color(0xFFF1743A);

  final AppThemePreference preference;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (preference) {
      case AppThemePreference.system:
        return Icons.brightness_auto_rounded;
      case AppThemePreference.light:
        return Icons.light_mode_rounded;
      case AppThemePreference.dark:
        return Icons.dark_mode_rounded;
    }
  }

  String get _label {
    switch (preference) {
      case AppThemePreference.system:
        return 'Sistem';
      case AppThemePreference.light:
        return 'Açık';
      case AppThemePreference.dark:
        return 'Koyu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected
                ? _orange.withValues(alpha: 0.12)
                : isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : _navy.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected
                  ? _orange.withValues(alpha: 0.55)
                  : isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : _navy.withValues(alpha: 0.05),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _icon,
                color: selected
                    ? _orange
                    : isDark
                        ? Colors.white70
                        : _navy,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                _label,
                maxLines: 1,
                style: TextStyle(
                  color: selected
                      ? _orange
                      : isDark
                          ? Colors.white70
                          : _navy,
                  fontSize: 10.5,
                  fontWeight: selected
                      ? FontWeight.w900
                      : FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
