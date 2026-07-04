import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/onboarding/application/providers/onboarding_providers.dart';
import 'package:meu_mobile/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:meu_mobile/shared/widgets/buttons/app_button.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await ref.read(onboardingLocalDataSourceProvider).setOnboardingCompleted();

    if (!mounted) return;

    context.go('/');
  }

  void _nextPage(List<OnboardingEntity> items) {
    final isLastPage = _currentIndex == items.length - 1;

    if (isLastPage) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(onboardingItemsProvider);
    final isLastPage = _currentIndex == items.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Geç'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingContent(item: items[index]);
                  },
                ),
              ),
              _OnboardingDots(
                itemCount: items.length,
                currentIndex: _currentIndex,
              ),
              const Gap(AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: isLastPage ? 'Başla' : 'Devam',
                  onPressed: () => _nextPage(items),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.item,
  });

  final OnboardingEntity item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppRadius.xl,
          ),
          child: Icon(
            item.icon,
            color: AppColors.primary,
            size: 92,
          ),
        ),
        const Gap(AppSpacing.xl),
        Text(
          item.title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const Gap(AppSpacing.md),
        Text(
          item.description,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({
    required this.itemCount,
    required this.currentIndex,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}