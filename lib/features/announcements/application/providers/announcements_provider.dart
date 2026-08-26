import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/announcements/data/datasources/announcements_remote_data_source.dart';
import 'package:meu_mobile/features/announcements/data/repositories/announcements_repository_impl.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/announcements/domain/repositories/announcements_repository.dart';

final announcementsRemoteDataSourceProvider =
    Provider<AnnouncementsRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      final cache = ref.watch(apiCacheServiceProvider);

      return DioAnnouncementsRemoteDataSource(dio, cache);
    });

final announcementsRepositoryProvider = Provider<AnnouncementsRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(announcementsRemoteDataSourceProvider);

  return AnnouncementsRepositoryImpl(remoteDataSource);
});

final announcementsProvider = FutureProvider<List<AnnouncementListItemEntity>>((
  ref,
) async {
  final repository = ref.watch(announcementsRepositoryProvider);

  return repository.getAnnouncements();
});

final announcementDetailProvider =
    FutureProvider.family<AnnouncementListItemEntity?, String>((ref, id) async {
      final repository = ref.watch(announcementsRepositoryProvider);

      return repository.getAnnouncementById(id);
    });

final selectedAnnouncementCategoryProvider =
    NotifierProvider<
      SelectedAnnouncementCategoryNotifier,
      AnnouncementCategory
    >(SelectedAnnouncementCategoryNotifier.new);

class SelectedAnnouncementCategoryNotifier
    extends Notifier<AnnouncementCategory> {
  @override
  AnnouncementCategory build() {
    return AnnouncementCategory.all;
  }

  void select(AnnouncementCategory category) {
    state = category;
  }
}

final announcementSearchQueryProvider =
    NotifierProvider<AnnouncementSearchQueryNotifier, String>(
      AnnouncementSearchQueryNotifier.new,
    );

class AnnouncementSearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

final filteredAnnouncementsProvider =
    FutureProvider<List<AnnouncementListItemEntity>>((ref) async {
      final announcements = await ref.watch(announcementsProvider.future);

      final selectedCategory = ref.watch(selectedAnnouncementCategoryProvider);

      final searchQuery = ref
          .watch(announcementSearchQueryProvider)
          .trim()
          .toLowerCase();

      return announcements.where((announcement) {
        final matchesCategory =
            selectedCategory == AnnouncementCategory.all ||
            announcement.category == selectedCategory;

        final title = announcement.title.toLowerCase();
        final description = announcement.description.toLowerCase();

        final matchesSearch =
            searchQuery.isEmpty ||
            title.contains(searchQuery) ||
            description.contains(searchQuery);

        return matchesCategory && matchesSearch;
      }).toList();
    });
