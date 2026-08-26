import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/features/clubs/presentation/theme/club_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';

class ClubListCard extends StatelessWidget {
  const ClubListCard({
    required this.club,
    this.onTap,
    super.key,
  });

  final StudentClubEntity club;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(
      club.category,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: ClubDesignTokens.surfaceDecoration(
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
                  _categoryIcon(club.category),
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
                          text: club.category.label,
                          foregroundColor: categoryColor,
                          backgroundColor: categoryColor
                              .withValues(alpha: 0.11),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.groups_rounded,
                          size: 14,
                          color:
                              ClubDesignTokens.secondaryText(
                            context,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          '${club.memberCount} üye',
                          style: TextStyle(
                            color:
                                ClubDesignTokens.secondaryText(
                              context,
                            ),
                            fontSize: 10.8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Gap(9),
                    Text(
                      club.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color:
                                ClubDesignTokens.primaryText(
                              context,
                            ),
                            fontSize: 15,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const Gap(5),
                    Text(
                      club.shortDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                ClubDesignTokens.secondaryText(
                              context,
                            ),
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
    StudentClubCategory category,
  ) {
    switch (category) {
      case StudentClubCategory.all:
        return Icons.groups_rounded;
      case StudentClubCategory.technology:
        return Icons.computer_rounded;
      case StudentClubCategory.culture:
        return Icons.palette_rounded;
      case StudentClubCategory.sport:
        return Icons.sports_basketball_rounded;
      case StudentClubCategory.social:
        return Icons.volunteer_activism_rounded;
      case StudentClubCategory.science:
        return Icons.science_rounded;
    }
  }

  Color _categoryColor(
    StudentClubCategory category,
  ) {
    switch (category) {
      case StudentClubCategory.all:
        return ClubDesignTokens.navy;
      case StudentClubCategory.technology:
        return ClubDesignTokens.purple;
      case StudentClubCategory.culture:
        return ClubDesignTokens.orange;
      case StudentClubCategory.sport:
        return ClubDesignTokens.green;
      case StudentClubCategory.social:
        return ClubDesignTokens.teal;
      case StudentClubCategory.science:
        return ClubDesignTokens.red;
    }
  }
}
