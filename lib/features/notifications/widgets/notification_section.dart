import 'package:flutter/material.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  /// Bölüm başlığı
  final String title;

  /// O bölüme ait bildirim kartları
  final List<Widget> children;

  /// Sayfa kenar boşluğu
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1743A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1743A).withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "${children.length}",
                    style: const TextStyle(
                      color: Color(0xFFF1743A),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          ...children,
        ],
      ),
    );
  }
}
