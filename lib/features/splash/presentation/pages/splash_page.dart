import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/constants/app_assets.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meu_mobile/core/cache/api_cache_service.dart';
import 'package:meu_mobile/features/onboarding/application/providers/onboarding_providers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 1900);

  late final AnimationController _controller;
  late final Animation<double> _logoLift;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoEffectsProgress;
  late final Animation<double> _orbitProgress;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _subtitleOpacity;
  late final Animation<Offset> _subtitleOffset;
  late final Animation<double> _footerOpacity;
  late final Animation<double> _loadingProgress;

  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    // Native splash logosu ekranın tam merkezindedir.
    // Flutter'ın ilk karesi de aynı yerde başlar ve sonra yukarı taşınır.
    _logoLift = Tween<double>(begin: 0, end: -72).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.04, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _logoScale =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 1, end: 1.035),
            weight: 45,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.035, end: 1),
            weight: 55,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.04, 0.42, curve: Curves.easeInOutCubic),
          ),
        );

    _logoEffectsProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.04, 0.34, curve: Curves.easeOut),
    );

    _orbitProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.10, 0.72, curve: Curves.easeOutCubic),
    );

    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.56, curve: Curves.easeOut),
    );

    _titleOffset = Tween<Offset>(begin: const Offset(0, 0.30), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.28, 0.60, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.70, curve: Curves.easeOut),
    );

    _subtitleOffset =
        Tween<Offset>(begin: const Offset(0, 0.24), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.42, 0.74, curve: Curves.easeOutCubic),
          ),
        );

    _footerOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.64, 0.90, curve: Curves.easeOut),
    );

    _loadingProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.56, 0.96, curve: Curves.easeInOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashFlow();
    });
  }

  Future<void> _startSplashFlow() async {
    if (_hasStarted) {
      return;
    }

    _hasStarted = true;

    final initializationFuture = _initializeAppServices();
    final onboardingFuture = _readOnboardingStatus();

    // Animasyon her durumda başlar.
    await _controller.forward();

    // Başlangıç servisleri animasyon sırasında hazırlanır.
    await initializationFuture;

    final hasCompletedOnboarding = await onboardingFuture;

    if (!mounted) {
      return;
    }

    context.go(hasCompletedOnboarding ? '/' : '/onboarding');
  }

  Future<void> _initializeAppServices() async {
    await Hive.initFlutter();

    if (!Hive.isBoxOpen(ApiCacheService.boxName)) {
      await Hive.openBox<String>(ApiCacheService.boxName);
    }
  }

  Future<bool> _readOnboardingStatus() async {
    try {
      return await ref
          .read(onboardingLocalDataSourceProvider)
          .hasCompletedOnboarding();
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _AnimatedSplashBackground(animation: _controller),
          Center(
            child: AnimatedBuilder(
              animation: _logoLift,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _logoLift.value),
                  child: child,
                );
              },
              child: ScaleTransition(
                scale: _logoScale,
                child: RepaintBoundary(
                  child: _AnimatedLogo(
                    orbitProgress: _orbitProgress,
                    effectsProgress: _logoEffectsProgress,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Transform.translate(
              offset: const Offset(0, 68),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleOffset,
                      child: const Text(
                        'MEUMOBİL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  FadeTransition(
                    opacity: _subtitleOpacity,
                    child: SlideTransition(
                      position: _subtitleOffset,
                      child: Text(
                        'Kampüs yaşamı tek uygulamada',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.78),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FadeTransition(
                  opacity: _footerOpacity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SplashLoadingBar(progress: _loadingProgress),
                      const Gap(18),
                      Text(
                        'MERSİN ÜNİVERSİTESİ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.66),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedLogo extends StatelessWidget {
  const _AnimatedLogo({
    required this.orbitProgress,
    required this.effectsProgress,
  });

  static const Color _accentColor = Color(0xFFF1743A);

  final Animation<double> orbitProgress;
  final Animation<double> effectsProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 164,
      height: 164,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: orbitProgress,
            builder: (context, child) {
              return CustomPaint(
                size: const Size.square(164),
                painter: _SplashOrbitPainter(
                  progress: orbitProgress.value,
                  accentColor: _accentColor,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: effectsProgress,
            builder: (context, child) {
              final progress = effectsProgress.value;

              return Container(
                width: 116,
                height: 116,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16 * progress),
                      blurRadius: 26 * progress,
                      offset: Offset(0, 12 * progress),
                    ),
                    BoxShadow(
                      color: _accentColor.withValues(alpha: 0.14 * progress),
                      blurRadius: 24 * progress,
                      spreadRadius: 1.5 * progress,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Image.asset(
              AppAssets.meuLogo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primary,
                  size: 58,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashLoadingBar extends StatelessWidget {
  const _SplashLoadingBar({required this.progress});

  static const Color _accentColor = Color(0xFFF1743A);

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        return SizedBox(
          width: 116,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(color: Colors.white.withValues(alpha: 0.14)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.value,
                    child: const ColoredBox(color: _accentColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSplashBackground extends StatelessWidget {
  const _AnimatedSplashBackground({required this.animation});

  static const Color _deepNavy = Color(0xFF0D1735);
  static const Color _accentColor = Color(0xFFF1743A);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = Curves.easeInOutCubic.transform(animation.value);

        return ColoredBox(
          color: AppColors.primary,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: progress,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, _deepNavy],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -130 + (progress * 18),
                right: -115 + (progress * 14),
                child: Opacity(
                  opacity: progress,
                  child: _GlowOrb(
                    size: 310,
                    color: Colors.white.withValues(alpha: 0.055),
                  ),
                ),
              ),
              Positioned(
                left: -150 + (progress * 20),
                bottom: -170 + (progress * 16),
                child: Opacity(
                  opacity: progress,
                  child: _GlowOrb(
                    size: 340,
                    color: _accentColor.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.42,
                left: -70 - (progress * 8),
                child: Opacity(
                  opacity: progress,
                  child: Transform.rotate(
                    angle: -0.22,
                    child: Container(
                      width: 190,
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.035),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _SplashOrbitPainter extends CustomPainter {
  const _SplashOrbitPainter({
    required this.progress,
    required this.accentColor,
  });

  final double progress;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) {
      return;
    }

    final center = size.center(Offset.zero);
    final radius = (size.shortestSide / 2) - 8;
    final orbitBounds = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawCircle(center, radius, basePaint);

    final startAngle = (-math.pi / 2) + (progress * math.pi * 0.28);
    final sweepAngle = math.pi * 0.92 * progress;

    final activePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.96 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.7
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(orbitBounds, startAngle, sweepAngle, false, activePaint);

    if (progress < 0.03) {
      return;
    }

    final dotAngle = startAngle + sweepAngle;
    final dotPosition = Offset(
      center.dx + (radius * math.cos(dotAngle)),
      center.dy + (radius * math.sin(dotAngle)),
    );

    canvas.drawCircle(
      dotPosition,
      4.2,
      Paint()..color = accentColor.withValues(alpha: progress),
    );

    canvas.drawCircle(
      dotPosition,
      8.5,
      Paint()..color = accentColor.withValues(alpha: 0.14 * progress),
    );
  }

  @override
  bool shouldRepaint(covariant _SplashOrbitPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.accentColor != accentColor;
  }
}
