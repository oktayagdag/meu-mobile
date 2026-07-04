import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_radius.dart';

class AppIconContainer extends StatelessWidget {
  const AppIconContainer({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    super.key,
    this.size = 54,
    this.iconSize = 28,
    this.radius,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: radius ?? AppRadius.lg,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}