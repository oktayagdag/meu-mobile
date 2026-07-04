import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_colors.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/clubs/application/providers/clubs_mock_provider.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/buttons/app_button.dart';
import 'package:meu_mobile/shared/widgets/cards/app_card.dart';
import 'package:meu_mobile/shared/widgets/icons/app_icon_container.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:meu_mobile/shared/utils/app_feedback.dart';

class ClubDetailPage extends ConsumerWidget {
  const ClubDetailPage({required this.clubId, super.key});

  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubs = ref.watch(clubsProvider);

    StudentClubEntity? club;

    for (final item in clubs) {
      if (item.id == clubId) {
        club = item;
        break;
      }
    }

    if (club == null) {
      return const Scaffold(
        body: EmptyState(
          title: 'Topluluk bulunamadı',
          description:
              'Açmak istediğin topluluk kaldırılmış veya güncellenmiş olabilir.',
          icon: Icons.groups_outlined,
        ),
      );
    }

    final categoryColor = _categoryColor(club.category);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Topluluk Detayı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIconContainer(
                        icon: _categoryIcon(club.category),
                        iconColor: categoryColor,
                        backgroundColor: categoryColor.withValues(alpha: 0.12),
                        size: 54,
                        iconSize: 30,
                      ),
                      const Gap(AppSpacing.md),
                      Expanded(
                        child: StatusBadge(
                          text: club.category.label,
                          foregroundColor: categoryColor,
                          backgroundColor: categoryColor.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.lg),
                  Text(
                    club.name,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  Text(
                    club.shortDescription,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    icon: Icons.person_rounded,
                    title: 'Başkan',
                    value: club.presidentName,
                  ),
                  const Gap(AppSpacing.md),
                  _InfoRow(
                    icon: Icons.groups_rounded,
                    title: 'Üye Sayısı',
                    value: '${club.memberCount} üye',
                  ),
                ],
              ),
            ),
            const Gap(AppSpacing.md),
            AppCard(
              child: Text(
                club.description,
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            ),
            const Gap(AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'WhatsApp',
                    icon: Icons.chat_rounded,
                    onPressed: () {
                      showComingSoonSnackBar(
                        context,
                        featureName: 'WhatsApp bağlantısı',
                      );
                    },
                  ),
                ),
                const Gap(AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    text: 'Instagram',
                    type: AppButtonType.secondary,
                    icon: Icons.camera_alt_rounded,
                    onPressed: () {
                      showComingSoonSnackBar(
                        context,
                        featureName: 'Instagram bağlantısı',
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(StudentClubCategory category) {
    switch (category) {
      case StudentClubCategory.all:
        return Icons.groups_rounded;
      case StudentClubCategory.technology:
        return Icons.memory_rounded;
      case StudentClubCategory.culture:
        return Icons.theater_comedy_rounded;
      case StudentClubCategory.sport:
        return Icons.sports_soccer_rounded;
      case StudentClubCategory.social:
        return Icons.volunteer_activism_rounded;
      case StudentClubCategory.science:
        return Icons.science_rounded;
    }
  }

  Color _categoryColor(StudentClubCategory category) {
    switch (category) {
      case StudentClubCategory.all:
        return AppColors.primary;
      case StudentClubCategory.technology:
        return AppColors.primary;
      case StudentClubCategory.culture:
        return AppColors.warning;
      case StudentClubCategory.sport:
        return AppColors.success;
      case StudentClubCategory.social:
        return AppColors.secondary;
      case StudentClubCategory.science:
        return AppColors.error;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const Gap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Gap(2),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
