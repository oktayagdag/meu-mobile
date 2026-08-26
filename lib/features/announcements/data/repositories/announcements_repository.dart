import 'package:meu_mobile/features/announcements/domain/entities/announcement_list_item_entity.dart';

abstract interface class AnnouncementsRepository {
  Future<List<AnnouncementListItemEntity>> getAnnouncements();

  Future<AnnouncementListItemEntity?> getAnnouncementById(String id);
}
