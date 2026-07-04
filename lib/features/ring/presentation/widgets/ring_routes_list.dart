import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_route_card.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';

class RingRoutesList extends StatelessWidget {
  const RingRoutesList({
    required this.routes,
    super.key,
  });

  final List<RingRouteEntity> routes;

  @override
  Widget build(BuildContext context) {
    if (routes.isEmpty) {
      return const EmptyState(
        title: 'Favori ring bulunamadı',
        description: 'Favori hat eklediğinde burada görünecek.',
        icon: Icons.star_border_rounded,
      );
    }

    return Column(
      children: List.generate(routes.length, (index) {
        return Column(
          children: [
            RingRouteCard(route: routes[index]),
            if (index != routes.length - 1) const Gap(AppSpacing.sm),
          ],
        );
      }),
    );
  }
}