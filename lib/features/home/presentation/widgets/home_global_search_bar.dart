import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeGlobalSearchBar extends StatelessWidget {
  const HomeGlobalSearchBar({
    this.resources,
    super.key,
  });

  final HomeResourcesEntity? resources;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showSearch<void>(
              context: context,
              delegate: _MeuSearchDelegate(
                destinations: _createDestinations(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(17),
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: HomeDesignTokens.surfaceDecoration(
              context,
              radius: 17,
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: HomeDesignTokens.orange
                        .withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: HomeDesignTokens.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Duyuru, etkinlik, ulaşım veya hizmet ara',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color:
                              HomeDesignTokens.secondaryText(context),
                          fontSize: 13,
                          height: 1,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: HomeDesignTokens.secondaryText(context),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_SearchDestination> _createDestinations() {
    final destinations = <_SearchDestination>[
      const _SearchDestination(
        title: 'Duyurular',
        description: 'Üniversite duyurularını görüntüle',
        keywords: 'duyuru ilan haber akademik idari',
        icon: Icons.campaign_rounded,
        route: '/announcements',
      ),
      const _SearchDestination(
        title: 'Etkinlikler',
        description: 'Kampüs etkinliklerini görüntüle',
        keywords: 'etkinlik konferans seminer konser söyleşi',
        icon: Icons.event_rounded,
        route: '/events',
      ),
      const _SearchDestination(
        title: 'Yemekhane',
        description: 'Günlük ve haftalık menüyü görüntüle',
        keywords: 'yemek menü öğle kalori yemekhane',
        icon: Icons.restaurant_menu_rounded,
        route: '/food',
      ),
      const _SearchDestination(
        title: 'Ulaşım',
        description: 'Kampüs ulaşım bilgilerini görüntüle',
        keywords: 'ring otobüs servis ulaşım durak',
        icon: Icons.directions_bus_rounded,
        route: '/ring',
      ),
      const _SearchDestination(
        title: 'Öğrenci Toplulukları',
        description: 'Kampüs topluluklarını görüntüle',
        keywords: 'topluluk kulüp öğrenci whatsapp sosyal',
        icon: Icons.groups_rounded,
        route: '/clubs',
      ),
      const _SearchDestination(
        title: 'Kampüs Haritası',
        description: 'Fakülte, ATM, kafe ve sosyal alanları bul',
        keywords: 'harita konum fakülte atm kafe yurt kültür',
        icon: Icons.map_rounded,
        route: '/campus-map',
      ),
      const _SearchDestination(
        title: 'Akademik Takvim',
        description: 'Akademik tarihleri görüntüle',
        keywords: 'takvim sınav kayıt tatil güz bahar',
        icon: Icons.calendar_month_rounded,
        route: '/academic-calendar',
      ),
      const _SearchDestination(
        title: 'Ayarlar',
        description: 'Uygulama ayarlarını aç',
        keywords: 'ayarlar önbellek tema bildirim',
        icon: Icons.settings_rounded,
        route: '/settings',
      ),
    ];

    final homeResources = resources;

    if (homeResources != null) {
      destinations.addAll(
        homeResources.quickActions.map(
          (item) {
            return _SearchDestination(
              title: item.title,
              description: 'Üniversite web hizmetini aç',
              keywords: '${item.title} öğrenci hizmet',
              icon: _iconForKey(item.iconKey),
              externalUrl: item.url,
            );
          },
        ),
      );

      destinations.addAll(
        homeResources.academicStats.map(
          (item) {
            return _SearchDestination(
              title: item.label,
              description: '${item.value} akademik kayıt',
              keywords:
                  '${item.label} akademik istatistik apbs ${item.value}',
              icon: _iconForKey(item.iconKey),
              externalUrl: item.url,
            );
          },
        ),
      );
    }

    return destinations;
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'school':
        return Icons.school_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'article':
        return Icons.article_outlined;
      case 'description':
        return Icons.description_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'project':
        return Icons.fact_check_rounded;
      case 'thesis':
        return Icons.book_rounded;
      case 'patent':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.open_in_new_rounded;
    }
  }
}

class _MeuSearchDelegate extends SearchDelegate<void> {
  _MeuSearchDelegate({
    required this.destinations,
  });

  final List<_SearchDestination> destinations;

  @override
  String get searchFieldLabel => 'MEUMOBİL’de ara';

  @override
  TextStyle? get searchFieldStyle {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return null;
    }

    return [
      IconButton(
        tooltip: 'Temizle',
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Geri',
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResultList(context);
  }

  Widget _buildResultList(BuildContext context) {
    final normalizedQuery = _normalize(query.trim());

    final filteredItems = normalizedQuery.isEmpty
        ? destinations
        : destinations.where((item) {
            final searchableText = _normalize(
              '${item.title} ${item.description} ${item.keywords}',
            );

            return searchableText.contains(normalizedQuery);
          }).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: HomeDesignTokens.orange
                      .withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 30,
                  color: HomeDesignTokens.orange,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sonuç bulunamadı',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Farklı bir kelimeyle tekrar aramayı dene.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: HomeDesignTokens.secondaryText(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredItems.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        final item = filteredItems[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _openDestination(context, item);
            },
            borderRadius: BorderRadius.circular(17),
            child: Ink(
              padding: const EdgeInsets.all(11),
              decoration: HomeDesignTokens.surfaceDecoration(
                context,
                radius: 17,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: HomeDesignTokens.navy
                          .withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      item.icon,
                      color: HomeDesignTokens.navy,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: HomeDesignTokens.primaryText(
                              context,
                            ),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: HomeDesignTokens.secondaryText(
                              context,
                            ),
                            fontSize: 11,
                            height: 1.25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    item.externalUrl == null
                        ? Icons.chevron_right_rounded
                        : Icons.open_in_new_rounded,
                    color: HomeDesignTokens.secondaryText(context),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openDestination(
    BuildContext context,
    _SearchDestination destination,
  ) async {
    final externalUrl = destination.externalUrl;

    if (externalUrl != null) {
      final uri = Uri.tryParse(externalUrl);

      if (uri == null ||
          !await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          )) {
        if (!context.mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bağlantı açılamadı.'),
          ),
        );

        return;
      }

      if (context.mounted) {
        close(context, null);
      }

      return;
    }

    final route = destination.route;

    if (route == null) {
      return;
    }

    close(context, null);

    await Future<void>.delayed(Duration.zero);

    if (context.mounted) {
      context.go(route);
    }
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('\u0307', '')
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');
  }
}

class _SearchDestination {
  const _SearchDestination({
    required this.title,
    required this.description,
    required this.keywords,
    required this.icon,
    this.route,
    this.externalUrl,
  });

  final String title;
  final String description;
  final String keywords;
  final IconData icon;
  final String? route;
  final String? externalUrl;
}
