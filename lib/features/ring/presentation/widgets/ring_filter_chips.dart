import 'package:flutter/material.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';

class RingFilterChips extends StatelessWidget {
  const RingFilterChips({super.key});

  static const _filters = [
    'Tümü',
    'Mühendislik',
    'Çiftlikköy',
    'Tıp',
    'Yenişehir',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ChoiceChip(
            selected: index == 0,
            label: Text(_filters[index]),
            onSelected: (_) {},
          );
        },
      ),
    );
  }
}