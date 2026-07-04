import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';

final clubsProvider = Provider<List<StudentClubEntity>>((ref) {
  return const [
    StudentClubEntity(
      id: 'technology-club',
      name: 'Teknoloji Topluluğu',
      shortDescription: 'Yazılım, yapay zeka ve girişimcilik odaklı öğrenci topluluğu.',
      description:
          'Teknoloji Topluluğu; yazılım geliştirme, yapay zeka, mobil uygulama, siber güvenlik ve girişimcilik alanlarında etkinlikler düzenleyen öğrenci topluluğudur.\n\n'
          'Topluluk; workshop, seminer, proje geliştirme günleri ve kariyer etkinlikleriyle öğrencilerin teknik gelişimine katkı sağlamayı hedefler.',
      category: StudentClubCategory.technology,
      memberCount: 248,
      presidentName: 'Topluluk Başkanı',
      whatsappUrl: 'https://chat.whatsapp.com/example',
      instagramUrl: 'https://instagram.com/example',
    ),
    StudentClubEntity(
      id: 'culture-art-club',
      name: 'Kültür ve Sanat Topluluğu',
      shortDescription: 'Tiyatro, müzik, sergi ve kültürel etkinlikler.',
      description:
          'Kültür ve Sanat Topluluğu; öğrencilerin sanatsal üretimlerini destekleyen ve kampüste kültürel etkinlikler düzenleyen bir topluluktur.\n\n'
          'Tiyatro, müzik, sergi, söyleşi ve film gösterimleri gibi etkinlikler düzenler.',
      category: StudentClubCategory.culture,
      memberCount: 173,
      presidentName: 'Topluluk Başkanı',
      whatsappUrl: 'https://chat.whatsapp.com/example',
      instagramUrl: 'https://instagram.com/example',
    ),
    StudentClubEntity(
      id: 'sports-club',
      name: 'Spor Topluluğu',
      shortDescription: 'Turnuvalar, spor etkinlikleri ve kampüs içi aktiviteler.',
      description:
          'Spor Topluluğu; fakülteler arası turnuvalar, antrenman programları ve kampüs içi sportif etkinlikler düzenler.\n\n'
          'Futbol, basketbol, voleybol ve koşu gibi branşlarda öğrencilerin aktif katılımını destekler.',
      category: StudentClubCategory.sport,
      memberCount: 312,
      presidentName: 'Topluluk Başkanı',
      whatsappUrl: 'https://chat.whatsapp.com/example',
      instagramUrl: 'https://instagram.com/example',
    ),
    StudentClubEntity(
      id: 'science-club',
      name: 'Bilim Topluluğu',
      shortDescription: 'Akademik söyleşiler, araştırma buluşmaları ve bilim etkinlikleri.',
      description:
          'Bilim Topluluğu; öğrencileri akademik araştırma kültürüyle buluşturmayı hedefler.\n\n'
          'Bilimsel söyleşiler, makale okuma grupları, araştırma sunumları ve laboratuvar ziyaretleri düzenler.',
      category: StudentClubCategory.science,
      memberCount: 126,
      presidentName: 'Topluluk Başkanı',
      whatsappUrl: 'https://chat.whatsapp.com/example',
      instagramUrl: 'https://instagram.com/example',
    ),
  ];
});

final selectedClubCategoryProvider =
    NotifierProvider<SelectedClubCategoryNotifier, StudentClubCategory>(
  SelectedClubCategoryNotifier.new,
);

class SelectedClubCategoryNotifier extends Notifier<StudentClubCategory> {
  @override
  StudentClubCategory build() {
    return StudentClubCategory.all;
  }

  void select(StudentClubCategory category) {
    state = category;
  }
}

final clubSearchQueryProvider =
    NotifierProvider<ClubSearchQueryNotifier, String>(
  ClubSearchQueryNotifier.new,
);

class ClubSearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void update(String value) {
    state = value;
  }
}

final filteredClubsProvider = Provider<List<StudentClubEntity>>((ref) {
  final clubs = ref.watch(clubsProvider);
  final selectedCategory = ref.watch(selectedClubCategoryProvider);
  final query = ref.watch(clubSearchQueryProvider).trim().toLowerCase();

  return clubs.where((club) {
    final matchesCategory = selectedCategory == StudentClubCategory.all ||
        club.category == selectedCategory;

    final matchesQuery = query.isEmpty ||
        club.name.toLowerCase().contains(query) ||
        club.shortDescription.toLowerCase().contains(query) ||
        club.description.toLowerCase().contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});