import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeExtraQuickActions extends StatelessWidget {
  const HomeExtraQuickActions({
    required this.items,
    super.key,
  });

  final List<HomeQuickLinkEntity> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 82,
        ),
        itemBuilder: (context, index) {
          return _ExtraQuickActionCard(
            item: items[index],
          );
        },
      ),
    );
  }
}

class _ExtraQuickActionCard extends StatelessWidget {
  const _ExtraQuickActionCard({
    required this.item,
  });

  final HomeQuickLinkEntity item;

  @override
  Widget build(BuildContext context) {
    final color = _iconColor(item.iconKey);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          _openUrl(context, item.url);
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            radius: 18,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  _iconForKey(item.iconKey),
                  color: color,
                  size: 22,
                ),
              ),
              const Gap(9),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: HomeDesignTokens.primaryText(context),
                        fontSize: 12.5,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: HomeDesignTokens.secondaryText(context),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(
    BuildContext context,
    String value,
  ) async {
    final uri = Uri.tryParse(value);

    if (uri == null ||
        !await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        )) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Bağlantı açılamadı.'),
          ),
        );
    }
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'school':
        return Icons.school_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.open_in_new_rounded;
    }
  }

  Color _iconColor(String key) {
    switch (key) {
      case 'wallet':
        return HomeDesignTokens.teal;
      case 'school':
      default:
        return HomeDesignTokens.purple;
    }
  }
}
