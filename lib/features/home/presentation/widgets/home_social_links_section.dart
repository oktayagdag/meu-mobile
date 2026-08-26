import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeSocialLinksSection extends StatelessWidget {
  const HomeSocialLinksSection({super.key});

  static const List<_SocialLinkItem> _items = [
    _SocialLinkItem(
      title: 'Instagram',
      icon: Icons.camera_alt_rounded,
      color: Color(0xFFE1306C),
      url: 'https://www.instagram.com/meukurumsal/',
    ),
    _SocialLinkItem(
      title: 'YouTube',
      icon: Icons.play_arrow_rounded,
      color: Color(0xFFFF0000),
      url: 'https://www.youtube.com/@meukurumsal',
    ),
    _SocialLinkItem(
      title: 'X',
      icon: Icons.alternate_email_rounded,
      color: Color(0xFF111111),
      url: 'https://x.com/meukurumsal',
    ),
    _SocialLinkItem(
      title: 'Facebook',
      icon: Icons.facebook_rounded,
      color: Color(0xFF1877F2),
      url: 'https://www.facebook.com/meukurumsal/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
          title: 'Bizi Takip Edin',
        ),
        const Gap(AppSpacing.homeSectionContent),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 13,
          ),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            radius: 20,
          ),
          child: Row(
            children: _items.map((item) {
              return Expanded(
                child: _SocialButton(
                  item: item,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.item,
  });

  final _SocialLinkItem item;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        HomeDesignTokens.isDark(context) && item.title == 'X'
            ? Colors.white
            : item.color;

    return Semantics(
      button: true,
      label: item.title,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _openUrl(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: effectiveColor,
                  size: 22,
                ),
              ),
              const Gap(7),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                      color: HomeDesignTokens.primaryText(context),
                      fontSize: 10.8,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context) async {
    final uri = Uri.tryParse(item.url);

    if (uri == null) {
      _showError(context);
      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Bağlantı açılamadı.'),
        ),
      );
  }
}

class _SocialLinkItem {
  const _SocialLinkItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.url,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String url;
}
