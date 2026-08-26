import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    this.trailing,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              12,
              12,
              12,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF6B7280),
                          fontSize: 11,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark
                          ? Colors.white38
                          : const Color(0xFF98A2B3),
                      size: 22,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      description: description,
      iconColor: iconColor,
      enabled: enabled,
      onTap: enabled
          ? () {
              onChanged(!value);
            }
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
