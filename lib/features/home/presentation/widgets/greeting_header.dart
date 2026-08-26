import 'package:flutter/material.dart';
import 'package:meu_mobile/app/constants/app_assets.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({required this.name, super.key, this.onNotificationTap});

  final String name;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF182958),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Image.asset(AppAssets.meuLogo, fit: BoxFit.contain),
              ),
              Expanded(
                child: Text(
                  'MEUMOBİL',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              SizedBox(
                width: 42,
                height: 42,
                child: IconButton(
                  onPressed: onNotificationTap,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
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
