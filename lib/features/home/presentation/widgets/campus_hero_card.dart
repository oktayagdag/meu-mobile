import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/constants/app_assets.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';

class CampusHeroCard extends StatelessWidget {
  const CampusHeroCard({super.key, this.onExploreTap});

  final VoidCallback? onExploreTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? theme.colorScheme.surface : Colors.white;

    final primaryTextColor = isDark ? Colors.white : HomeDesignTokens.navy;

    final secondaryTextColor = isDark
        ? Colors.white.withValues(alpha: 0.62)
        : const Color(0xFF667085);

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onExploreTap,
      child: SizedBox(
        height: 200,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : HomeDesignTokens.navy.withValues(alpha: 0.07),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned(
                    right: -38,
                    top: -46,
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: HomeDesignTokens.orange.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    bottom: -62,
                    child: Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: HomeDesignTokens.navy.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 22,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 82,
                        height: 82,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: HomeDesignTokens.orange.withValues(
                            alpha: 0.09,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HomeDesignTokens.orange.withValues(
                              alpha: 0.20,
                            ),
                          ),
                        ),
                        child: Image.asset(
                          AppAssets.meuLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: SizedBox(
                        width: constraints.maxWidth * 0.62,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MEUMOBİL',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 16,
                                  height: 1.05,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.35,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                'Kampüs yaşamına tek noktadan eriş.',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: secondaryTextColor,
                                      fontSize: 11,
                                      height: 1.15,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const Gap(7),
                              SizedBox(
                                height: 31,
                                child: FilledButton.icon(
                                  onPressed: onExploreTap,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: HomeDesignTokens.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 11,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.explore_rounded,
                                    size: 15,
                                  ),
                                  label: const Text(
                                    'Kampüsü Keşfet',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      height: 1,
                                      fontWeight: FontWeight.w900,
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
