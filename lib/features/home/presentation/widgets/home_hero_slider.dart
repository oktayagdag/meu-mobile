import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/presentation/widgets/campus_hero_card.dart';

class HomeHeroSlider extends StatefulWidget {
  const HomeHeroSlider({required this.onExploreTap, super.key});

  final VoidCallback onExploreTap;

  @override
  State<HomeHeroSlider> createState() => _HomeHeroSliderState();
}

class _HomeHeroSliderState extends State<HomeHeroSlider> {
  final PageController _pageController = PageController();

  static const double _sliderAspectRatio = 1000 / 355;

  static const List<String> _imagePaths = [
    'assets/images/home_slider_1.jpg',
    'assets/images/home_slider_2.jpg',
    'assets/images/home_slider_3.jpg',
    'assets/images/home_slider_4.jpeg',
    'assets/images/home_slider_5.jpg',
    'assets/images/home_slider_6.jpg',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  int get _itemCount => _imagePaths.length + 1;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) {
        return;
      }

      final nextIndex = (_currentIndex + 1) % _itemCount;

      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _openImagePreview(String imagePath) async {
    _timer?.cancel();

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Görseli kapat',
      barrierColor: Colors.black.withValues(alpha: 0.90),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _SliderImagePreview(imagePath: imagePath);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );

    if (mounted) {
      _startAutoSlide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: _sliderAspectRatio,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _itemCount,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox.expand(
                  child: CampusHeroCard(onExploreTap: widget.onExploreTap),
                );
              }

              final imagePath = _imagePaths[index - 1];

              return _SliderImageCard(
                imagePath: imagePath,
                onTap: () {
                  _openImagePreview(imagePath);
                },
              );
            },
          ),
        ),
        const Gap(AppSpacing.sm),
        _SliderDots(itemCount: _itemCount, currentIndex: _currentIndex),
      ],
    );
  }
}

class _SliderImageCard extends StatelessWidget {
  const _SliderImageCard({required this.imagePath, required this.onTap});

  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Görseli büyüt',
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'home-slider-$imagePath',
          child: Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              color: AppColors.primary.withValues(alpha: 0.06),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return const _SliderImageFallback();
                  },
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.58),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.zoom_in_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderImagePreview extends StatelessWidget {
  const _SliderImagePreview({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 64, 12, 24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: Hero(
                        tag: 'home-slider-$imagePath',
                        child: Material(
                          color: Colors.transparent,
                          child: InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            boundaryMargin: const EdgeInsets.all(80),
                            clipBehavior: Clip.none,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: ClipRRect(
                                borderRadius: AppRadius.card,
                                child: ColoredBox(
                                  color: Colors.black,
                                  child: Image.asset(
                                    imagePath,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const _SliderImageFallback();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 12,
              child: Material(
                color: Colors.white.withValues(alpha: 0.16),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Kapat',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 6,
              child: Text(
                'Yakınlaştırmak için iki parmağını kullan',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderImageFallback extends StatelessWidget {
  const _SliderImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.secondary.withValues(alpha: 0.90),
          ],
        ),
      ),
      child: Icon(
        Icons.school_rounded,
        size: 72,
        color: Colors.white.withValues(alpha: 0.18),
      ),
    );
  }
}

class _SliderDots extends StatelessWidget {
  const _SliderDots({required this.itemCount, required this.currentIndex});

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final selected = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: selected ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
