import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/campus_map/domain/entities/campus_location_entity.dart';

final campusLocationsProvider = Provider<List<CampusLocationEntity>>((ref) {
  return const [
    CampusLocationEntity(
      id: 'engineering-faculty',
      name: 'Mühendislik Fakültesi',
      description: 'Mühendislik bölümlerinin derslik ve akademik birimleri.',
      category: CampusLocationCategory.faculty,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '5 dk',
      addressText: 'Ana kampüs içi akademik bölge',
    ),
    CampusLocationEntity(
      id: 'central-library',
      name: 'Merkez Kütüphane',
      description: 'Çalışma salonları, kaynak kitaplar ve sessiz çalışma alanları.',
      category: CampusLocationCategory.library,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '7 dk',
      addressText: 'Merkez kampüs kütüphane bölgesi',
    ),
    CampusLocationEntity(
      id: 'central-cafeteria',
      name: 'Merkez Yemekhane',
      description: 'Öğrenci ve personel yemek hizmeti verilen ana yemekhane.',
      category: CampusLocationCategory.cafeteria,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '4 dk',
      addressText: 'Öğrenci yaşam alanı yakını',
    ),
    CampusLocationEntity(
      id: 'ring-stop-main',
      name: 'Ana Ring Durağı',
      description: 'Kampüs içi ring servislerinin ana durak noktası.',
      category: CampusLocationCategory.transport,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '2 dk',
      addressText: 'Ana giriş ve öğrenci alanı çevresi',
    ),
    CampusLocationEntity(
      id: 'student-affairs',
      name: 'Öğrenci İşleri',
      description: 'Öğrenci belge, kayıt ve başvuru işlemleri.',
      category: CampusLocationCategory.administrative,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '6 dk',
      addressText: 'İdari birimler bölgesi',
    ),
    CampusLocationEntity(
      id: 'culture-center',
      name: 'Kültür Merkezi',
      description: 'Konferans, seminer ve öğrenci etkinlikleri alanı.',
      category: CampusLocationCategory.social,
      campus: 'Çiftlikköy Kampüsü',
      walkingTime: '8 dk',
      addressText: 'Etkinlik ve sosyal alanlar bölgesi',
    ),
  ];
});

final selectedCampusLocationCategoryProvider =
    NotifierProvider<SelectedCampusLocationCategoryNotifier,
        CampusLocationCategory>(
  SelectedCampusLocationCategoryNotifier.new,
);

class SelectedCampusLocationCategoryNotifier
    extends Notifier<CampusLocationCategory> {
  @override
  CampusLocationCategory build() {
    return CampusLocationCategory.all;
  }

  void select(CampusLocationCategory category) {
    state = category;
  }
}

final campusLocationSearchQueryProvider =
    NotifierProvider<CampusLocationSearchQueryNotifier, String>(
  CampusLocationSearchQueryNotifier.new,
);

class CampusLocationSearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }
}

final filteredCampusLocationsProvider =
    Provider<List<CampusLocationEntity>>((ref) {
  final locations = ref.watch(campusLocationsProvider);
  final selectedCategory = ref.watch(selectedCampusLocationCategoryProvider);
  final query = ref.watch(campusLocationSearchQueryProvider).trim().toLowerCase();

  return locations.where((location) {
    final matchesCategory = selectedCategory == CampusLocationCategory.all ||
        location.category == selectedCategory;

    final matchesQuery = query.isEmpty ||
        location.name.toLowerCase().contains(query) ||
        location.description.toLowerCase().contains(query) ||
        location.campus.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});