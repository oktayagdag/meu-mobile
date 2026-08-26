import 'package:meu_mobile/features/clubs/data/datasources/clubs_remote_data_source.dart';
import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';
import 'package:meu_mobile/features/clubs/domain/repositories/clubs_repository.dart';

class ClubsRepositoryImpl implements ClubsRepository {
  const ClubsRepositoryImpl(this._remoteDataSource);

  final ClubsRemoteDataSource _remoteDataSource;

  @override
  Future<List<StudentClubEntity>> getClubs() async {
    final models = await _remoteDataSource.fetchClubs();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<StudentClubEntity?> getClubById(String id) async {
    final model = await _remoteDataSource.fetchClubById(id);

    return model?.toEntity();
  }
}
