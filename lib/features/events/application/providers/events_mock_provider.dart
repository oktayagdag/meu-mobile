import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/events/domain/entities/campus_event_entity.dart';

final eventsProvider = Provider<List<CampusEventEntity>>((ref) {
  return const [
    CampusEventEntity(
      id: 'tech-community-event',
      title: 'Teknoloji Topluluğu Etkinliği',
      description: 'Yapay zeka ve mobil uygulama geliştirme üzerine öğrenci buluşması.',
      content:
          'Teknoloji Topluluğu tarafından düzenlenen bu etkinlikte yapay zeka, mobil uygulama geliştirme ve girişimcilik üzerine oturumlar yapılacaktır.\n\n'
          'Etkinlikte öğrenciler sektör temsilcileriyle bir araya gelerek kariyer fırsatları hakkında bilgi alabilecektir.\n\n'
          'Katılım tüm öğrencilere açıktır.',
      category: CampusEventCategory.community,
      date: 'Bugün',
      time: '14:00',
      location: 'Konferans Salonu',
      organizer: 'Teknoloji Topluluğu',
    ),
    CampusEventEntity(
      id: 'career-conference',
      title: 'Kariyer Planlama Konferansı',
      description: 'Mezuniyet sonrası kariyer planlama ve staj fırsatları konuşulacak.',
      content:
          'Kariyer Merkezi tarafından düzenlenen konferansta CV hazırlama, staj bulma, mülakat süreçleri ve kariyer planlama konuları ele alınacaktır.\n\n'
          'Etkinlik sonunda soru-cevap bölümü yapılacaktır.',
      category: CampusEventCategory.conference,
      date: 'Yarın',
      time: '11:00',
      location: 'Prof. Dr. Uğur Oral Kültür Merkezi',
      organizer: 'Kariyer Merkezi',
    ),
    CampusEventEntity(
      id: 'spring-festival',
      title: 'Bahar Şenliği',
      description: 'Öğrenci toplulukları, konserler ve kampüs etkinlikleri.',
      content:
          'Bahar Şenliği kapsamında kampüs alanında konserler, öğrenci toplulukları stantları ve çeşitli sosyal etkinlikler düzenlenecektir.\n\n'
          'Etkinlik boyunca öğrenci kimliği ile giriş yapılacaktır.',
      category: CampusEventCategory.culture,
      date: '5 Temmuz',
      time: '17:00',
      location: 'Çiftlikköy Kampüsü',
      organizer: 'Sağlık, Kültür ve Spor Daire Başkanlığı',
    ),
    CampusEventEntity(
      id: 'football-tournament',
      title: 'Fakülteler Arası Futbol Turnuvası',
      description: 'Fakülteler arası futbol turnuvası başlıyor.',
      content:
          'Fakülteler arası futbol turnuvası için başvurular başlamıştır.\n\n'
          'Takımlar fakülte temsilcileri aracılığıyla kayıt yaptırabilir. Maç programı başvurular tamamlandıktan sonra duyurulacaktır.',
      category: CampusEventCategory.sport,
      date: '8 Temmuz',
      time: '16:00',
      location: 'Spor Tesisleri',
      organizer: 'Spor Koordinatörlüğü',
    ),
  ];
});

final selectedEventCategoryProvider =
    NotifierProvider<SelectedEventCategoryNotifier, CampusEventCategory>(
  SelectedEventCategoryNotifier.new,
);

class SelectedEventCategoryNotifier extends Notifier<CampusEventCategory> {
  @override
  CampusEventCategory build() {
    return CampusEventCategory.all;
  }

  void select(CampusEventCategory category) {
    state = category;
  }
}

final eventSearchQueryProvider =
    NotifierProvider<EventSearchQueryNotifier, String>(
  EventSearchQueryNotifier.new,
);

class EventSearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }
}

final filteredEventsProvider = Provider<List<CampusEventEntity>>((ref) {
  final events = ref.watch(eventsProvider);
  final selectedCategory = ref.watch(selectedEventCategoryProvider);
  final query = ref.watch(eventSearchQueryProvider).trim().toLowerCase();

  return events.where((event) {
    final matchesCategory =
        selectedCategory == CampusEventCategory.all ||
        event.category == selectedCategory;

    final matchesQuery = query.isEmpty ||
        event.title.toLowerCase().contains(query) ||
        event.description.toLowerCase().contains(query) ||
        event.location.toLowerCase().contains(query) ||
        event.organizer.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});