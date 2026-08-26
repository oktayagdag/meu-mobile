import 'package:flutter/material.dart';

class NotificationEmpty extends StatelessWidget {
  const NotificationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFF1743A).withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: Color(0xFFF1743A),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Henüz bildirimin yok",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Yeni duyurular, etkinlikler, yemekhane güncellemeleri ve sistem bildirimleri burada görünecek.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Yenile"),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF1743A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
