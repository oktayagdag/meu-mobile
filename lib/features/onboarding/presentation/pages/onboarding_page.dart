import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/constants/app_assets.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/onboarding/application/providers/onboarding_providers.dart';
import 'package:meu_mobile/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

  int _currentIndex = 0;
  bool _isCompleting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) {
      return;
    }

    HapticFeedback.selectionClick();

    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) {
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      _isCompleting = true;
    });

    try {
      await ref
          .read(onboardingLocalDataSourceProvider)
          .setOnboardingCompleted();

      if (!mounted) {
        return;
      }

      context.go('/');
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karşılama işlemi tamamlanamadı. Tekrar deneyin.'),
        ),
      );
    }
  }

  void _nextPage(List<OnboardingEntity> items) {
    final isLastPage = _currentIndex == items.length - 1;

    if (isLastPage) {
      _completeOnboarding();
      return;
    }

    HapticFeedback.lightImpact();

    _pageController.nextPage(
      duration: const Duration(milliseconds: 440),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    if (_currentIndex == 0) {
      return;
    }

    HapticFeedback.lightImpact();

    _pageController.previousPage(
      duration: const Duration(milliseconds: 440),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(onboardingItemsProvider);

    final currentItem = items[_currentIndex];
    final palette = _OnboardingPalette.fromType(currentItem.visualType);

    final isLastPage = _currentIndex == items.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF080E21),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, palette.background],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _OnboardingBackground(palette: palette),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    12,
                    AppSpacing.md,
                    18,
                  ),
                  child: Column(
                    children: [
                      _OnboardingHeader(
                        palette: palette,
                        isLastPage: isLastPage,
                        onSkip: _isCompleting ? null : _completeOnboarding,
                      ),
                      const Gap(8),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: items.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            return _OnboardingSlide(
                              item: items[index],
                              index: index,
                              currentIndex: _currentIndex,
                              pageController: _pageController,
                            );
                          },
                        ),
                      ),
                      _OnboardingFooter(
                        currentIndex: _currentIndex,
                        itemCount: items.length,
                        palette: palette,
                        isLastPage: isLastPage,
                        isLoading: _isCompleting,
                        onBack: _previousPage,
                        onNext: () {
                          _nextPage(items);
                        },
                      ),
                    ],
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

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.palette,
    required this.isLastPage,
    required this.onSkip,
  });

  final _OnboardingPalette palette;
  final bool isLastPage;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Image.asset(AppAssets.meuLogo, fit: BoxFit.contain),
        ),
        const Gap(10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MEUMOBİL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Mersin Üniversitesi',
                style: TextStyle(
                  color: Color(0xBFFFFFFF),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: isLastPage ? 0 : 1,
          child: IgnorePointer(
            ignoring: isLastPage,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                ),
              ),
              child: const Text(
                'Geç',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.item,
    required this.index,
    required this.currentIndex,
    required this.pageController,
  });

  final OnboardingEntity item;
  final int index;
  final int currentIndex;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final palette = _OnboardingPalette.fromType(item.visualType);

    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        final currentPage = pageController.hasClients
            ? pageController.page ?? currentIndex.toDouble()
            : currentIndex.toDouble();

        final pageDifference = index - currentPage;

        final distance = pageDifference.abs().clamp(0.0, 1.0);

        final isActive = index == currentIndex;

        return Transform.translate(
          offset: Offset(pageDifference * 18, 0),
          child: Opacity(
            opacity: 1 - (distance * 0.22),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final visualSize = (constraints.maxHeight * 0.48).clamp(
                  220.0,
                  292.0,
                );

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _OnboardingVisual(
                      item: item,
                      palette: palette,
                      active: isActive,
                      size: visualSize,
                    ),
                    const Gap(24),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                      offset: isActive ? Offset.zero : const Offset(0, 0.08),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 360),
                        opacity: isActive ? 1 : 0.55,
                        child: Column(
                          children: [
                            Text(
                              item.eyebrow,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: palette.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.1,
                              ),
                            ),
                            const Gap(10),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 29,
                                height: 1.08,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Gap(13),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                item.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  fontSize: 14,
                                  height: 1.48,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual({
    required this.item,
    required this.palette,
    required this.active,
    required this.size,
  });

  final OnboardingEntity item;
  final _OnboardingPalette palette;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    final config = _OnboardingVisualConfig.fromType(item.visualType);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutBack,
            scale: active ? 1 : 0.90,
            child: Container(
              width: size * 0.88,
              height: size * 0.88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.accent.withValues(alpha: 0.16),
                    palette.accent.withValues(alpha: 0.025),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
              ),
            ),
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            turns: active ? 0.02 : -0.03,
            child: Container(
              width: size * 0.68,
              height: size * 0.68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: palette.accent.withValues(alpha: 0.28),
                  width: 1.4,
                ),
              ),
            ),
          ),
          AnimatedScale(
            duration: const Duration(milliseconds: 520),
            curve: Curves.easeOutBack,
            scale: active ? 1 : 0.84,
            child: Container(
              width: size * 0.39,
              height: size * 0.39,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.20),
                  width: 1.3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: palette.accent.withValues(alpha: 0.22),
                    blurRadius: 34,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                config.mainIcon,
                color: Colors.white,
                size: size * 0.18,
              ),
            ),
          ),
          Positioned(
            top: size * 0.04,
            left: 0,
            child: _AnimatedFeaturePill(
              active: active,
              delay: const Duration(milliseconds: 60),
              icon: config.featureIcons[0],
              label: item.highlights[0],
              palette: palette,
              entryOffset: const Offset(-0.20, 0.12),
            ),
          ),
          Positioned(
            right: 0,
            top: size * 0.37,
            child: _AnimatedFeaturePill(
              active: active,
              delay: const Duration(milliseconds: 130),
              icon: config.featureIcons[1],
              label: item.highlights[1],
              palette: palette,
              entryOffset: const Offset(0.20, 0.04),
            ),
          ),
          Positioned(
            bottom: size * 0.02,
            left: size * 0.13,
            child: _AnimatedFeaturePill(
              active: active,
              delay: const Duration(milliseconds: 200),
              icon: config.featureIcons[2],
              label: item.highlights[2],
              palette: palette,
              entryOffset: const Offset(-0.08, 0.20),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFeaturePill extends StatelessWidget {
  const _AnimatedFeaturePill({
    required this.active,
    required this.delay,
    required this.icon,
    required this.label,
    required this.palette,
    required this.entryOffset,
  });

  final bool active;
  final Duration delay;
  final IconData icon;
  final String label;
  final _OnboardingPalette palette;
  final Offset entryOffset;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 360 + delay.inMilliseconds);

    return AnimatedSlide(
      duration: duration,
      curve: Curves.easeOutBack,
      offset: active ? Offset.zero : entryOffset,
      child: AnimatedOpacity(
        duration: duration,
        opacity: active ? 1 : 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 154),
          padding: const EdgeInsets.fromLTRB(8, 7, 11, 7),
          decoration: BoxDecoration(
            color: const Color(0xFF13264F).withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 16,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: palette.accent, size: 15),
              ),
              const Gap(7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
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

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.currentIndex,
    required this.itemCount,
    required this.palette,
    required this.isLastPage,
    required this.isLoading,
    required this.onBack,
    required this.onNext,
  });

  final int currentIndex;
  final int itemCount;
  final _OnboardingPalette palette;
  final bool isLastPage;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _OnboardingDots(
              itemCount: itemCount,
              currentIndex: currentIndex,
              accentColor: palette.accent,
            ),
            const Spacer(),
            Text(
              '${currentIndex + 1}'
              ' / '
              '$itemCount',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const Gap(18),
        Row(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: currentIndex == 0 ? 0 : 1,
              child: IgnorePointer(
                ignoring: currentIndex == 0,
                child: Material(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onBack,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _OnboardingPrimaryButton(
                text: isLastPage ? 'Uygulamayı Keşfet' : 'Devam Et',
                palette: palette,
                isLastPage: isLastPage,
                isLoading: isLoading,
                onPressed: onNext,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardingPrimaryButton extends StatelessWidget {
  const _OnboardingPrimaryButton({
    required this.text,
    required this.palette,
    required this.isLastPage,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final _OnboardingPalette palette;
  final bool isLastPage;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isLastPage ? Colors.white : AppColors.primary;

    return Material(
      color: isLastPage ? palette.accent : Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: foregroundColor,
                          ),
                        )
                      : Text(
                          text,
                          key: ValueKey(text),
                          style: TextStyle(
                            color: foregroundColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
                if (!isLoading) ...[
                  const Gap(10),
                  Icon(
                    isLastPage
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                    color: foregroundColor,
                    size: 19,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({
    required this.itemCount,
    required this.currentIndex,
    required this.accentColor,
  });

  final int itemCount;
  final int currentIndex;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(right: 6),
          width: isActive ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? accentColor
                : Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground({required this.palette});

  final _OnboardingPalette palette;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            top: -110,
            right: -90,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 520),
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.accent.withValues(alpha: 0.15),
                    palette.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -140,
            bottom: -170,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 520),
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    palette.secondary.withValues(alpha: 0.10),
                    palette.secondary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPalette {
  const _OnboardingPalette({
    required this.accent,
    required this.secondary,
    required this.background,
  });

  final Color accent;
  final Color secondary;
  final Color background;

  static _OnboardingPalette fromType(OnboardingVisualType type) {
    switch (type) {
      case OnboardingVisualType.campus:
        return const _OnboardingPalette(
          accent: Color(0xFFF1743A),
          secondary: Color(0xFFFFB17D),
          background: Color(0xFF0D1735),
        );

      case OnboardingVisualType.map:
        return const _OnboardingPalette(
          accent: Color(0xFF43C7BE),
          secondary: Color(0xFF85E5DC),
          background: Color(0xFF0B2635),
        );

      case OnboardingVisualType.dailyLife:
        return const _OnboardingPalette(
          accent: Color(0xFFF5B84B),
          secondary: Color(0xFFFFDA8D),
          background: Color(0xFF2E2118),
        );

      case OnboardingVisualType.notifications:
        return const _OnboardingPalette(
          accent: Color(0xFF9A8CFF),
          secondary: Color(0xFFC3BAFF),
          background: Color(0xFF211A43),
        );
    }
  }
}

class _OnboardingVisualConfig {
  const _OnboardingVisualConfig({
    required this.mainIcon,
    required this.featureIcons,
  });

  final IconData mainIcon;
  final List<IconData> featureIcons;

  static _OnboardingVisualConfig fromType(OnboardingVisualType type) {
    switch (type) {
      case OnboardingVisualType.campus:
        return const _OnboardingVisualConfig(
          mainIcon: Icons.dashboard_customize_rounded,
          featureIcons: [
            Icons.campaign_rounded,
            Icons.event_rounded,
            Icons.calendar_month_rounded,
          ],
        );

      case OnboardingVisualType.map:
        return const _OnboardingVisualConfig(
          mainIcon: Icons.map_rounded,
          featureIcons: [
            Icons.account_balance_rounded,
            Icons.location_on_rounded,
            Icons.navigation_rounded,
          ],
        );

      case OnboardingVisualType.dailyLife:
        return const _OnboardingVisualConfig(
          mainIcon: Icons.auto_awesome_motion_rounded,
          featureIcons: [
            Icons.restaurant_menu_rounded,
            Icons.directions_bus_rounded,
            Icons.bolt_rounded,
          ],
        );

      case OnboardingVisualType.notifications:
        return const _OnboardingVisualConfig(
          mainIcon: Icons.notifications_active_rounded,
          featureIcons: [
            Icons.campaign_rounded,
            Icons.event_available_rounded,
            Icons.tune_rounded,
          ],
        );
    }
  }
}
