import 'package:meu_mobile/features/announcements/data/datasources/announcements_remote_data_source.dart';
import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';
import 'package:meu_mobile/features/announcements/domain/repositories/announcements_repository.dart';

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  const AnnouncementsRepositoryImpl(this._remoteDataSource);

  final AnnouncementsRemoteDataSource _remoteDataSource;

  @override
  Future<List<AnnouncementListItemEntity>> getAnnouncements() async {
    final models = await _remoteDataSource.fetchAnnouncements();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AnnouncementListItemEntity?> getAnnouncementById(String id) async {
    final model = await _remoteDataSource.fetchAnnouncementById(id);

    return model?.toEntity();
  }
}
