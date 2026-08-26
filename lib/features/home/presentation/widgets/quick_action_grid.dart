import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_QuickActionItem> _items = [
    _QuickActionItem(
      title: 'Akademik Takvim',
      icon: Icons.calendar_month_rounded,
      route: '/academic-calendar',
      color: HomeDesignTokens.purple,
    ),
    _QuickActionItem(
      title: 'Kampüs Haritası',
      icon: Icons.map_rounded,
      route: '/campus-map',
      color: HomeDesignTokens.teal,
    ),
    _QuickActionItem(
      title: 'Yemek',
      icon: Icons.restaurant_rounded,
      route: '/food',
      color: HomeDesignTokens.orange,
    ),
    _QuickActionItem(
      title: 'Ulaşım',
      icon: Icons.directions_bus_rounded,
      route: '/ring',
      color: HomeDesignTokens.navy,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        return _QuickActionCard(
          item: _items[index],
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.item,
  });

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          context.go(item.route);
        },
        child: Ink(
          padding: const EdgeInsets.fromLTRB(6, 9, 6, 7),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            radius: 18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 21,
                ),
              ),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: HomeDesignTokens.primaryText(context),
                        fontSize: 10.8,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });

  final String title;
  final IconData icon;
  final String route;
  final Color color;
}
