import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';

final announcementsProvider = Provider<List<AnnouncementListItemEntity>>((ref) {
  return const [
    AnnouncementListItemEntity(
      id: 'spring-festival',
      title: 'Bahar Şenliği Hakkında',
      description: 'Bahar şenliği etkinlik programı ve katılım detayları yayınlandı.',
      content:
          'Mersin Üniversitesi Bahar Şenliği kapsamında düzenlenecek etkinlik programı yayınlanmıştır.\n\n'
          'Etkinlik takvimi, konser alanı, öğrenci topluluklarının stant yerleri ve katılım koşulları ile ilgili detaylara üniversitemizin resmi duyuru kanallarından ulaşabilirsiniz.\n\n'
          'Öğrencilerimizin etkinlik alanlarında güvenlik kurallarına uymaları ve öğrenci kimliklerini yanlarında bulundurmaları önemle rica olunur.',
      category: AnnouncementCategory.event,
      timeAgo: '1 saat önce',
      publishedAt: '2 Temmuz 2026',
    ),
    AnnouncementListItemEntity(
      id: 'summer-school',
      title: 'Yaz Okulu Kayıtları Başladı',
      description: '2026 yaz okulu başvuru ve kayıt tarihleri duyuruldu.',
      content:
          '2026 yaz okulu kayıtları başlamıştır.\n\n'
          'Öğrencilerimiz ders seçimi, ücret ödeme ve kesin kayıt işlemlerini akademik takvimde belirtilen tarihler arasında tamamlamalıdır.\n\n'
          'Başvuru süreciyle ilgili detaylı bilgi fakülte öğrenci işleri birimlerinden alınabilir.',
      category: AnnouncementCategory.academic,
      timeAgo: '3 saat önce',
      publishedAt: '2 Temmuz 2026',
    ),
    AnnouncementListItemEntity(
      id: 'library-hours',
      title: 'Kütüphane Çalışma Saatleri',
      description: 'Final haftası boyunca kütüphane çalışma saatleri güncellendi.',
      content:
          'Final haftası nedeniyle merkez kütüphane çalışma saatleri geçici olarak güncellenmiştir.\n\n'
          'Öğrencilerimiz belirtilen tarihler arasında kütüphaneden daha uzun süre faydalanabilecektir.\n\n'
          'Yoğunluk yaşanmaması adına çalışma salonlarında sessizlik kurallarına uyulması rica olunur.',
      category: AnnouncementCategory.administrative,
      timeAgo: '1 gün önce',
      publishedAt: '1 Temmuz 2026',
    ),
    AnnouncementListItemEntity(
      id: 'internship-applications',
      title: 'Staj Başvuruları Hakkında',
      description: 'Zorunlu staj başvuruları için gerekli belgeler açıklandı.',
      content:
          'Zorunlu staj başvurusu yapacak öğrenciler için gerekli belge listesi yayınlanmıştır.\n\n'
          'Başvuru formu, iş yeri kabul belgesi ve sigorta işlemleri için gereken evrakların belirtilen tarihe kadar teslim edilmesi gerekmektedir.\n\n'
          'Eksik belge ile yapılan başvurular değerlendirmeye alınmayacaktır.',
      category: AnnouncementCategory.academic,
      timeAgo: '2 gün önce',
      publishedAt: '30 Haziran 2026',
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