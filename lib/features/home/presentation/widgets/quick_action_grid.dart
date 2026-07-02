import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const _items = [
    _QuickActionItem(Icons.restaurant_rounded, 'Yemek'),
    _QuickActionItem(Icons.directions_bus_rounded, 'Ring'),
    _QuickActionItem(Icons.campaign_rounded, 'Duyuru'),
    _QuickActionItem(Icons.event_rounded, 'Etkinlik'),
    _QuickActionItem(Icons.groups_rounded, 'Topluluk'),
    _QuickActionItem(Icons.calendar_month_rounded, 'Takvim'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
      ),
      itemBuilder: (context, index) {
        final item = _items[index];

        return AppCard(
          onTap: () {},
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 28),
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem(this.icon, this.label);

  final IconData icon;
  final String label;
}