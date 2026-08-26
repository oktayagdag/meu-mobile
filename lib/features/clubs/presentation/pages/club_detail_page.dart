import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/clubs/application/providers/clubs_provider.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/features/clubs/presentation/theme/club_design_tokens.dart';
import 'package:meu_mobile/shared/widgets/badges/status_badge.dart';
import 'package:meu_mobile/shared/widgets/states/app_error_state.dart';
import 'package:meu_mobile/shared/widgets/states/app_loading_state.dart';
import 'package:meu_mobile/shared/widgets/states/empty_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ClubDetailPage extends ConsumerWidget {
  const ClubDetailPage({
    required this.clubId,
    super.key,
  });

  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clubAsync = ref.watch(
      clubDetailProvider(clubId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topluluk Detayı'),
      ),
      body: clubAsync.when(
        loading: () {
          return const AppLoadingState(
            message: 'Topluluk bilgileri yükleniyor...',
          );
        },
        error: (error, stackTrace) {
          return AppErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(
                clubDetailProvider(clubId),
              );
            },
          );
        },
        data: (club) {
          if (club == null) {
            return const EmptyState(
              title: 'Topluluk bulunamadı',
              description:
                  'Bu topluluk kaldırılmış veya erişilemiyor olabilir.',
              icon: Icons.groups_outlined,
            );
          }

          return _ClubDetailContent(
            club: club,
          );
        },
      ),
    );
  }
}

class _ClubDetailContent extends StatelessWidget {
  const _ClubDetailContent({
    required this.club,
  });

  final StudentClubEntity club;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(
      club.category,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClubDetailHero(
            club: club,
            categoryColor: categoryColor,
            categoryIcon: _categoryIcon(
              club.category,
            ),
          ),
          if (club.presidentName.trim().isNotEmpty) ...[
            const Gap(12),
            _ClubPresidentCard(
              presidentName: club.presidentName,
              accentColor: categoryColor,
            ),
          ],
          const Gap(12),
          _ClubDescriptionCard(
            description: club.description,
            categoryColor: categoryColor,
          ),
          if (club.whatsappUrl.trim().isNotEmpty ||
              club.instagramUrl.trim().isNotEmpty) ...[
            const Gap(12),
            _ClubContactCard(
              whatsappUrl: club.whatsappUrl,
              instagramUrl: club.instagramUrl,
              accentColor: categoryColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _ClubDetailHero extends StatelessWidget {
  const _ClubDetailHero({
    required this.club,
    required this.categoryColor,
    required this.categoryIcon,
  });

  final StudentClubEntity club;
  final Color categoryColor;
  final IconData categoryIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: ClubDesignTokens.surfaceDecoration(
        context,
        accent: categoryColor,
        radius: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color:
                      categoryColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: 27,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    StatusBadge(
                      text: club.category.label,
                      foregroundColor: categoryColor,
                      backgroundColor: categoryColor
                          .withValues(alpha: 0.11),
                    ),
                    const Gap(7),
                    Row(
                      children: [
                        Icon(
                          Icons.groups_rounded,
                          size: 14,
                          color:
                              ClubDesignTokens.secondaryText(
                            context,
                          ),
                        ),
                        const Gap(5),
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
                  ],
                ),
              ),
            ],
          ),
          const Gap(18),
          Text(
            club.name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                  color: ClubDesignTokens.primaryText(
                    context,
                  ),
                  fontSize: 22,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
          ),
          const Gap(10),
          Text(
            club.shortDescription,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: ClubDesignTokens.secondaryText(
                    context,
                  ),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _ClubPresidentCard extends StatelessWidget {
  const _ClubPresidentCard({
    required this.presidentName,
    required this.accentColor,
  });

  final String presidentName;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: ClubDesignTokens.surfaceDecoration(
        context,
        radius: 20,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.person_rounded,
              color: accentColor,
              size: 22,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Topluluk Başkanı',
                  style: TextStyle(
                    color:
                        ClubDesignTokens.secondaryText(
                      context,
                    ),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(3),
                Text(
                  presidentName,
                  style: TextStyle(
                    color:
                        ClubDesignTokens.primaryText(
                      context,
                    ),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubDescriptionCard extends StatelessWidget {
  const _ClubDescriptionCard({
    required this.description,
    required this.categoryColor,
  });

  final String description;
  final Color categoryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: ClubDesignTokens.surfaceDecoration(
        context,
        radius: 22,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius:
                      BorderRadius.circular(99),
                ),
              ),
              const Gap(9),
              Text(
                'Topluluk Hakkında',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color:
                          ClubDesignTokens.primaryText(
                        context,
                      ),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const Gap(14),
          Text(
            description,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(
                  color:
                      ClubDesignTokens.primaryText(
                    context,
                  ),
                  fontSize: 14,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}

class _ClubContactCard extends StatelessWidget {
  const _ClubContactCard({
    required this.whatsappUrl,
    required this.instagramUrl,
    required this.accentColor,
  });

  final String whatsappUrl;
  final String instagramUrl;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: ClubDesignTokens.surfaceDecoration(
        context,
        radius: 22,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius:
                      BorderRadius.circular(99),
                ),
              ),
              const Gap(9),
              Text(
                'Topluluğa Ulaş',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color:
                          ClubDesignTokens.primaryText(
                        context,
                      ),
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const Gap(14),
          if (whatsappUrl.trim().isNotEmpty)
            FilledButton.icon(
              onPressed: () {
                _openExternalUrl(
                  context,
                  whatsappUrl,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    ClubDesignTokens.green,
                foregroundColor: Colors.white,
                minimumSize:
                    const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(
                Icons.chat_rounded,
                size: 20,
              ),
              label: const Text(
                'WhatsApp Grubuna Katıl',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          if (whatsappUrl.trim().isNotEmpty &&
              instagramUrl.trim().isNotEmpty)
            const Gap(9),
          if (instagramUrl.trim().isNotEmpty)
            OutlinedButton.icon(
              onPressed: () {
                _openExternalUrl(
                  context,
                  instagramUrl,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    ClubDesignTokens.purple,
                side: BorderSide(
                  color: ClubDesignTokens.purple.withValues(
                    alpha: 0.45,
                  ),
                ),
                minimumSize:
                    const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
              ),
              label: const Text(
                'Instagram',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openExternalUrl(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      _showError(context);
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Bağlantı açılamadı.'),
        ),
      );
  }
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
