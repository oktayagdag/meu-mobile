import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/ring/domain/entities/ring_route_entity.dart';
import 'package:meu_mobile/features/ring/presentation/widgets/ring_route_card.dart';

class RingRoutesList extends StatelessWidget {
  const RingRoutesList({required this.routes, super.key});

  final List<RingRouteEntity> routes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(routes.length, (index) {
        final route = routes[index];

        return Column(
          children: [
            RingRouteCard(route: route),
            if (index != routes.length - 1) const Gap(AppSpacing.sm),
          ],
        );
      }),
    );
  }
}
