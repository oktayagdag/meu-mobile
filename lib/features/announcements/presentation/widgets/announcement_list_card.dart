import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/announcements/presentation/theme/announcement_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';

class AnnouncementListCard extends StatelessWidget {
  const AnnouncementListCard({
    required this.announcement,
    super.key,
    this.onTap,
  });

  final AnnouncementListItemEntity announcement;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(
      announcement.category,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration:
              AnnouncementDesignTokens.surfaceDecoration(
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
                  _categoryIcon(
                    announcement.category,
                  ),
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
                    Row(
                      children: [
                        StatusBadge(
                          text:
                              announcement.category.label,
                          foregroundColor: categoryColor,
                          backgroundColor: categoryColor
                              .withValues(alpha: 0.11),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: Color(0xFF98A2B3),
                        ),
                        const Gap(4),
                        Flexible(
                          child: Text(
                            announcement.timeAgo,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  AnnouncementDesignTokens
                                      .secondaryText(
                                context,
                              ),
                              fontSize: 10.5,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(9),
                    Text(
                      announcement.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color:
                                AnnouncementDesignTokens
                                    .primaryText(context),
                            fontSize: 15,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Gap(5),
                    Text(
                      announcement.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                AnnouncementDesignTokens
                                    .secondaryText(context),
                            fontSize: 12,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
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
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return Icons.campaign_rounded;
      case AnnouncementCategory.academic:
        return Icons.school_rounded;
      case AnnouncementCategory.administrative:
        return Icons.account_balance_rounded;
      case AnnouncementCategory.event:
        return Icons.event_rounded;
    }
  }

  Color _categoryColor(
    AnnouncementCategory category,
  ) {
    switch (category) {
      case AnnouncementCategory.all:
        return AnnouncementDesignTokens.navy;
      case AnnouncementCategory.academic:
        return AnnouncementDesignTokens.green;
      case AnnouncementCategory.administrative:
        return AnnouncementDesignTokens.purple;
      case AnnouncementCategory.event:
        return AnnouncementDesignTokens.orange;
    }
  }
}
