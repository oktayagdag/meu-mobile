import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';
import 'package:meu_mobile/features/events/presentation/theme/event_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';

class EventListCard extends StatelessWidget {
  const EventListCard({
    required this.event,
    this.onTap,
    super.key,
  });

  final CampusEventEntity event;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(
      event.category,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: EventDesignTokens.surfaceDecoration(
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
                  color:
                      categoryColor.withValues(alpha: 0.11),
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      runSpacing: 5,
                      children: [
                        StatusBadge(
                          text: event.category.label,
                          foregroundColor: categoryColor,
                          backgroundColor: categoryColor
                              .withValues(alpha: 0.11),
                        ),
                        StatusBadge(
                          text: event.date,
                          foregroundColor:
                              EventDesignTokens.navy,
                          backgroundColor:
                              EventDesignTokens.navy
                                  .withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    const Gap(9),
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color:
                                EventDesignTokens.primaryText(
                              context,
                            ),
                            fontSize: 15,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Gap(5),
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                EventDesignTokens.secondaryText(
                              context,
                            ),
                            fontSize: 12,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Gap(9),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color:
                              EventDesignTokens.secondaryText(
                            context,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          event.time,
                          style: TextStyle(
                            color:
                                EventDesignTokens.secondaryText(
                              context,
                            ),
                            fontSize: 10.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(10),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color:
                              EventDesignTokens.secondaryText(
                            context,
                          ),
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  EventDesignTokens.secondaryText(
                                context,
                              ),
                              fontSize: 10.8,
                              fontWeight: FontWeight.w600,
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
                  color:
                      categoryColor.withValues(alpha: 0.09),
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
        return EventDesignTokens.navy;
      case CampusEventCategory.conference:
        return EventDesignTokens.purple;
      case CampusEventCategory.community:
        return EventDesignTokens.teal;
      case CampusEventCategory.culture:
        return EventDesignTokens.orange;
      case CampusEventCategory.sport:
        return EventDesignTokens.green;
    }
  }
}
