import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:meu_mobile/app/theme/app_spacing.dart';
import 'package:meu_mobile/features/home/domain/entities/home_resources_entity.dart';
import 'package:meu_mobile/features/home/presentation/theme/home_design_tokens.dart';
import 'package:meu_mobile/features/home/presentation/widgets/home_section_title.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademicStatsSection extends StatelessWidget {
  const AcademicStatsSection({
    required this.items,
    super.key,
  });

  final List<HomeAcademicStatEntity> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(
          title: 'Akademik İstatistikler',
        ),
        const Gap(8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) {
              return const Gap(AppSpacing.md);
            },
            itemBuilder: (context, index) {
              return _AcademicStatCard(
                item: items[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AcademicStatCard extends StatelessWidget {
  const _AcademicStatCard({
    required this.item,
  });

  final HomeAcademicStatEntity item;

  @override
  Widget build(BuildContext context) {
    final color = _parseHexColor(item.colorHex);

    return SizedBox(
      width: 168,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            _openUrl(context, item.url);
          },
          child: Ink(
            padding: const EdgeInsets.all(13),
            decoration: HomeDesignTokens.surfaceDecoration(
              context,
              radius: 18,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    _iconForKey(item.iconKey),
                    color: color,
                    size: 21,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              color:
                                  HomeDesignTokens.primaryText(context),
                              fontSize: 14,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const Gap(5),
                      Text(
                        item.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: HomeDesignTokens.secondaryText(
                                context,
                              ),
                              fontSize: 10.5,
                              height: 1.15,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(
    BuildContext context,
    String value,
  ) async {
    final uri = Uri.tryParse(value);

    if (uri == null ||
        !await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        )) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Bağlantı açılamadı.'),
          ),
        );
    }
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'article':
        return Icons.article_outlined;
      case 'description':
        return Icons.description_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'project':
        return Icons.fact_check_rounded;
      case 'thesis':
        return Icons.book_rounded;
      case 'patent':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _parseHexColor(String value) {
    final cleanedValue = value.replaceAll('#', '').trim();
    final normalizedValue = cleanedValue.length == 6
        ? 'FF$cleanedValue'
        : cleanedValue;

    final parsedValue = int.tryParse(
      normalizedValue,
      radix: 16,
    );

    return Color(parsedValue ?? 0xFF7C64D5);
  }
}
