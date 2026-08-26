import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
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
                  _categoryIcon(announcement.category),
                  color: categoryColor,
                  size: 23,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      text: announcement.category.label,
                      foregroundColor: categoryColor,
                      backgroundColor:
                          categoryColor.withValues(alpha: 0.11),
                    ),
                    const Gap(8),
                    Text(
                      announcement.title,
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
                    Text(
                      announcement.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                HomeDesignTokens.secondaryText(context),
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
        return HomeDesignTokens.navy;
      case AnnouncementCategory.academic:
        return HomeDesignTokens.green;
      case AnnouncementCategory.administrative:
        return HomeDesignTokens.purple;
      case AnnouncementCategory.event:
        return HomeDesignTokens.orange;
    }
  }
}
