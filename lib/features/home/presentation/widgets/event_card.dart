import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.event,
    super.key,
    this.onTap,
  });

  final CampusEventEntity event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(event.category);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: HomeDesignTokens.surfaceDecoration(
            context,
            accent: categoryColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _categoryIcon(event.category),
                  color: categoryColor,
                  size: 23,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      children: [
                        StatusBadge(
                          text: event.category.label,
                          foregroundColor: categoryColor,
                          backgroundColor:
                              categoryColor.withValues(alpha: 0.11),
                        ),
                        StatusBadge(
                          text: event.date,
                          foregroundColor: HomeDesignTokens.navy,
                          backgroundColor: HomeDesignTokens.navy
                              .withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.primaryText(context),
                            fontSize: 15,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: HomeDesignTokens.secondaryText(context),
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            '${event.time} • ${event.location}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: HomeDesignTokens.secondaryText(
                                    context,
                                  ),
                                  fontSize: 11.8,
                                  height: 1.30,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: categoryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return Icons.event_rounded;
      case CampusEventCategory.conference:
        return Icons.mic_rounded;
      case CampusEventCategory.community:
        return Icons.groups_rounded;
      case CampusEventCategory.culture:
        return Icons.theater_comedy_rounded;
      case CampusEventCategory.sport:
        return Icons.sports_soccer_rounded;
    }
  }

  Color _categoryColor(
    CampusEventCategory category,
  ) {
    switch (category) {
      case CampusEventCategory.all:
        return HomeDesignTokens.navy;
      case CampusEventCategory.conference:
        return HomeDesignTokens.purple;
      case CampusEventCategory.community:
        return HomeDesignTokens.teal;
      case CampusEventCategory.culture:
        return HomeDesignTokens.orange;
      case CampusEventCategory.sport:
        return HomeDesignTokens.green;
    }
  }
}
