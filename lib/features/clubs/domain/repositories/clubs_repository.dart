import 'package:meu_mobile/features/clubs/domain/entities/student_club_entity.dart';

abstract interface class ClubsRepository {
  Future<List<StudentClubEntity>> getClubs();

  Future<StudentClubEntity?> getClubById(String id);
}
