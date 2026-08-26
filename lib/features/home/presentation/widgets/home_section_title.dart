import 'package:flutter/material.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';

class HomeSectionTitle extends StatelessWidget {
  const HomeSectionTitle({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: HomeDesignTokens.orange,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: HomeDesignTokens.primaryText(context),
                  fontSize: 17,
                  height: 1.10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.20,
                ),
          ),
        ),
      ],
    );
  }
}
