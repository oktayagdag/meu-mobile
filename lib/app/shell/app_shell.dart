import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/providers/side_menu_controller_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const Color _menuBackgroundColor = Color(0xFF182958);

  // Menü metinleri ve URL'ler daha sonra buraya eklenecek.
  //
  // Örnek:
  // _SideMenuLink(
  //   title: 'Öğrenci Bilgi Sistemi',
  //   url: 'https://obs.mersin.edu.tr/',
  // )
  static const List<_SideMenuLink> _sideMenuLinks = [
    _SideMenuLink(title: 'Website Anasayfa', url: 'https://www.mersin.edu.tr/'),
    _SideMenuLink(
      title: 'Aday Öğrenci',
      url: 'https://tanitim.mersin.edu.tr/tr',
    ),
    _SideMenuLink(
      title: 'Kampüste Yaşam',
      url: 'https://tanitim.mersin.edu.tr/tr/universitemiz/kampuste-yasam',
    ),
    _SideMenuLink(title: 'Uzaktan Eğitim', url: 'https://ue.mersin.edu.tr/'),
    _SideMenuLink(title: 'Kütüphane', url: 'https://kutuphane.mersin.edu.tr/'),
    _SideMenuLink(
      title: 'Fakülteler',
      url: 'https://tanitim.mersin.edu.tr/tr/fakulteler',
    ),
    _SideMenuLink(title: 'Hastane', url: 'https://hastane.mersin.edu.tr/'),
    _SideMenuLink(
      title: 'İletişim',
      url: 'https://tanitim.mersin.edu.tr/tr/iletisim',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMenuOpen = ref.watch(sideMenuControllerProvider);

    final menuController = ref.read(sideMenuControllerProvider.notifier);

    final screenWidth = MediaQuery.sizeOf(context).width;
    final menuWidth = (screenWidth * 0.70).clamp(245.0, 300.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF182958),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
      child: PopScope<void>(
        canPop: !isMenuOpen,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isMenuOpen) {
            menuController.close();
          }
        },
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeInOutCubic,
          tween: Tween<double>(begin: 0, end: isMenuOpen ? 1 : 0),
          builder: (context, animationValue, child) {
            final foregroundScale = 1 - (animationValue * 0.12);

            final foregroundOffset = menuWidth * 0.93 * animationValue;

            final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

            final snappedForegroundOffset =
                (foregroundOffset * devicePixelRatio).round() /
                devicePixelRatio;

            final topSeamHeight = 2 / devicePixelRatio;
            final foregroundColor = Theme.of(context).scaffoldBackgroundColor;

            final borderRadius = 30 * animationValue;

            final menuOpacity = Curves.easeOut.transform(animationValue);

            return Scaffold(
              backgroundColor: _menuBackgroundColor,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  _SideMenu(
                    width: menuWidth,
                    animationValue: menuOpacity,
                    links: _sideMenuLinks,
                    onLinkTap: (link) {
                      menuController.close();
                      _openExternalLink(context, link.url);
                    },
                  ),
                  Transform.translate(
                    offset: Offset(snappedForegroundOffset, 0),
                    child: Transform.scale(
                      alignment: Alignment.centerLeft,
                      scale: foregroundScale,

                      // Ölçekleme sırasında kenarlardan beyaz piksel örneklenmesini engeller.
                      filterQuality: FilterQuality.none,

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          boxShadow: animationValue <= 0
                              ? const []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.28 * animationValue,
                                    ),
                                    blurRadius: 28,
                                    spreadRadius: 2,
                                    offset: const Offset(-7, 8),
                                  ),
                                ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),

                          // Anti-alias kaynaklı beyaz kenar parlamasını kapatır.
                          clipBehavior: Clip.hardEdge,

                          child: ColoredBox(
                            color: foregroundColor,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                IgnorePointer(
                                  ignoring: isMenuOpen,
                                  child: _MainAppScaffold(
                                    navigationShell: navigationShell,
                                  ),
                                ),

                                // Üst kenardaki fiziksel piksel birleşim çizgisini kapatır.
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  height: topSeamHeight,
                                  child: const IgnorePointer(
                                    child: ColoredBox(color: Color(0xFF182958)),
                                  ),
                                ),

                                if (animationValue > 0.01)
                                  Positioned.fill(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: menuController.close,
                                      child: ColoredBox(
                                        color: Colors.black.withValues(
                                          alpha: 0.025 * animationValue,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openExternalLink(BuildContext context, String value) async {
    final uri = Uri.tryParse(value);

    if (uri == null) {
      _showUrlError(context);
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && context.mounted) {
      _showUrlError(context);
    }
  }

  void _showUrlError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı.')));
  }
}

class _MainAppScaffold extends StatelessWidget {
  const _MainAppScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const double _bottomNavHeight = 66;
  static const double _bottomNavGap = 10;
  static const double _bottomNavSafety = 12;

  @override
  Widget build(BuildContext context) {
    final systemBottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final bottomContentClearance =
        _bottomNavHeight + _bottomNavGap + _bottomNavSafety + systemBottomInset;

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: bottomContentClearance,
        ),
        child: navigationShell,
      ),
      bottomNavigationBar: _ModernBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({
    required this.width,
    required this.animationValue,
    required this.links,
    required this.onLinkTap,
  });

  final double width;
  final double animationValue;
  final List<_SideMenuLink> links;
  final ValueChanged<_SideMenuLink> onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: width,
      child: SafeArea(
        child: Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(-26 * (1 - animationValue), 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 38, 34, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/meu_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) {
                              return const Icon(
                                Icons.account_balance_rounded,
                                color: Colors.white,
                                size: 58,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          'MEÜ MOBILE',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                                height: 1,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(links.length, (index) {
                          final link = links[index];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == links.length - 1 ? 0 : 5,
                            ),
                            child: _SideMenuTextButton(
                              title: link.title,
                              animationValue: animationValue,
                              animationIndex: index,
                              onTap: () {
                                onLinkTap(link);
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SideMenuTextButton extends StatelessWidget {
  const _SideMenuTextButton({
    required this.title,
    required this.animationValue,
    required this.animationIndex,
    required this.onTap,
  });

  final String title;
  final double animationValue;
  final int animationIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final itemDelay = animationIndex * 0.045;

    final itemProgress = ((animationValue - itemDelay) / (1 - itemDelay)).clamp(
      0.0,
      1.0,
    );

    return Opacity(
      opacity: itemProgress,
      child: Transform.translate(
        offset: Offset(-18 * (1 - itemProgress), 0),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 11),
            minimumSize: const Size(double.infinity, 44),
            alignment: Alignment.centerLeft,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.open_in_new_rounded,
                color: Colors.white70,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenuLink {
  const _SideMenuLink({required this.title, required this.url});

  final String title;
  final String url;
}

class _ModernBottomNavigation extends StatelessWidget {
  const _ModernBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  static const Color _navbarColor = Color(0xFF182958);

  static const List<_BottomNavigationItem> _items = [
    _BottomNavigationItem(
      label: 'Ana Sayfa',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _BottomNavigationItem(
      label: 'Duyurular',
      icon: Icons.article_outlined,
      selectedIcon: Icons.article_rounded,
    ),
    _BottomNavigationItem(
      label: 'Etkinlikler',
      icon: Icons.event_outlined,
      selectedIcon: Icons.event_rounded,
    ),
    _BottomNavigationItem(
      label: 'Topluluklar',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups_rounded,
    ),
    _BottomNavigationItem(
      label: 'Ayarlar',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
    ),
  ];

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Container(
        height: 66,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: _navbarColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 22,
              offset: const Offset(0, 9),
            ),
            BoxShadow(
              color: _navbarColor.withValues(alpha: 0.20),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final selectedWidth = (constraints.maxWidth * 0.39)
                .clamp(122.0, 136.0)
                .toDouble();

            final collapsedWidth =
                (constraints.maxWidth - selectedWidth) / (_items.length - 1);

            return Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final selected = currentIndex == index;

                return AnimatedContainer(
                  width: selected ? selectedWidth : collapsedWidth,
                  height: double.infinity,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.16)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: selected
                        ? Border.all(
                            color: Colors.white.withValues(alpha: 0.10),
                          )
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {
                        onDestinationSelected(index);
                      },
                      child: LayoutBuilder(
                        builder: (context, itemConstraints) {
                          final showLabel =
                              selected && itemConstraints.maxWidth >= 92;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: showLabel ? 12 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: showLabel
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.center,
                              children: [
                                Icon(
                                  selected ? item.selectedIcon : item.icon,
                                  size: selected ? 23.5 : 22.5,
                                  color: selected
                                      ? const Color(0xFFF05100)
                                      : Colors.white.withValues(alpha: 0.78),
                                ),
                                if (showLabel) ...[
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 11.5,
                                            height: 1,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
