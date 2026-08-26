import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';

class LiveTransitCard extends StatelessWidget {
  const LiveTransitCard({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            radius: 20,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: HomeDesignTokens.navy.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: HomeDesignTokens.navy,
                  size: 25,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: HomeDesignTokens.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'CANLI ULAŞIM',
                          style: TextStyle(
                            color: HomeDesignTokens.primaryText(context),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                    Text(
                      'Yakındaki duraklar, gelen araçlar ve canlı takip',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: HomeDesignTokens.secondaryText(context),
                        fontSize: 10.5,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: HomeDesignTokens.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: HomeDesignTokens.orange,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

