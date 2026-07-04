import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';

final announcementsProvider = Provider<List<AnnouncementListItemEntity>>((ref) {
  return const [
    AnnouncementListItemEntity(
      title: 'Bahar Şenliği Hakkında',
      description: 'Bahar şenliği etkinlik programı ve katılım detayları yayınlandı.',
      category: AnnouncementCategory.event,
      timeAgo: '1 saat önce',
    ),
    AnnouncementListItemEntity(
      title: 'Yaz Okulu Kayıtları Başladı',
      description: '2026 yaz okulu başvuru ve kayıt tarihleri duyuruldu.',
      category: AnnouncementCategory.academic,
      timeAgo: '3 saat önce',
    ),
    AnnouncementListItemEntity(
      title: 'Kütüphane Çalışma Saatleri',
      description: 'Final haftası boyunca kütüphane çalışma saatleri güncellendi.',
      category: AnnouncementCategory.administrative,
      timeAgo: '1 gün önce',
    ),
    AnnouncementListItemEntity(
      title: 'Staj Başvuruları Hakkında',
      description: 'Zorunlu staj başvuruları için gerekli belgeler açıklandı.',
      category: AnnouncementCategory.academic,
      timeAgo: '2 gün önce',
    ),
  ];
});

final selectedAnnouncementCategoryProvider =
    NotifierProvider<SelectedAnnouncementCategoryNotifier, AnnouncementCategory>(
  SelectedAnnouncementCategoryNotifier.new,
);

class SelectedAnnouncementCategoryNotifier extends Notifier<AnnouncementCategory> {
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
}

final filteredAnnouncementsProvider =
    Provider<List<AnnouncementListItemEntity>>((ref) {
  final announcements = ref.watch(announcementsProvider);
  final selectedCategory = ref.watch(selectedAnnouncementCategoryProvider);
  final query = ref.watch(announcementSearchQueryProvider).trim().toLowerCase();

  return announcements.where((announcement) {
    final matchesCategory = selectedCategory == AnnouncementCategory.all ||
        announcement.category == selectedCategory;

    final matchesQuery = query.isEmpty ||
        announcement.title.toLowerCase().contains(query) ||
        announcement.description.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});