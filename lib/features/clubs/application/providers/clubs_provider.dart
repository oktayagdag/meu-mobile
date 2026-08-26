import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/core/cache/cache_provider.dart';
import 'package:meu_mobile/core/network/dio_client.dart';
import 'package:meu_mobile/features/clubs/data/datasources/clubs_remote_data_source.dart';
import 'package:meu_mobile/features/clubs/data/repositories/clubs_repository_impl.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/features/clubs/domain/repositories/clubs_repository.dart';

final clubsRemoteDataSourceProvider = Provider<ClubsRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(apiCacheServiceProvider);

  return DioClubsRemoteDataSource(dio, cache);
});

final clubsRepositoryProvider = Provider<ClubsRepository>((ref) {
  final remoteDataSource = ref.watch(clubsRemoteDataSourceProvider);

  return ClubsRepositoryImpl(remoteDataSource);
});

final clubsProvider = FutureProvider<List<StudentClubEntity>>((ref) async {
  final repository = ref.watch(clubsRepositoryProvider);

  return repository.getClubs();
});

final clubDetailProvider = FutureProvider.family<StudentClubEntity?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(clubsRepositoryProvider);

  return repository.getClubById(id);
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

  void clear() {
    state = '';
  }
}

final filteredClubsProvider = FutureProvider<List<StudentClubEntity>>((
  ref,
) async {
  final clubs = await ref.watch(clubsProvider.future);

  final category = ref.watch(selectedClubCategoryProvider);

  final query = ref.watch(clubSearchQueryProvider).trim().toLowerCase();

  return clubs.where((club) {
    final matchesCategory =
        category == StudentClubCategory.all || club.category == category;

    final name = club.name.toLowerCase();
    final shortDescription = club.shortDescription.toLowerCase();
    final description = club.description.toLowerCase();
    final presidentName = club.presidentName.toLowerCase();

    final matchesQuery =
        query.isEmpty ||
        name.contains(query) ||
        shortDescription.contains(query) ||
        description.contains(query) ||
        presidentName.contains(query);

    return matchesCategory && matchesQuery;
  }).toList();
});
