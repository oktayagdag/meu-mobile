import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    this.description,
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 3),
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF6B7280),
                    fontSize: 11.5,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 9),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : const Color(0xFF182958)
                      .withValues(alpha: 0.07),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.12 : 0.035,
                ),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              children.length,
              (index) {
                return Column(
                  children: [
                    children[index],
                    if (index != children.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 68,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFF182958)
                                .withValues(alpha: 0.055),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
