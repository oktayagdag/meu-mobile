import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/profile/domain/entities/user_profile_entity.dart';

final userProfileProvider = Provider<UserProfileEntity>((ref) {
  return const UserProfileEntity(
    fullName: 'Oktay Akdağ',
    department: 'Bilişim Sistemleri ve Teknolojileri',
    studentNumber: 'Öğrenci No',
    email: 'oktayyagdagg@gmail.com',
    initials: 'OA',
  );
});

final profileStatsProvider = Provider<List<ProfileStatEntity>>((ref) {
  return const [
    ProfileStatEntity(title: 'Favori Hat', value: '2'),
    ProfileStatEntity(title: 'Takip Edilen', value: '4'),
    ProfileStatEntity(title: 'Bildirim', value: 'Açık'),
  ];
});

final announcementNotificationProvider =
    NotifierProvider<AnnouncementNotificationNotifier, bool>(
  AnnouncementNotificationNotifier.new,
);

class AnnouncementNotificationNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void toggle(bool value) {
    state = value;
  }
}

final cafeteriaReminderProvider =
    NotifierProvider<CafeteriaReminderNotifier, bool>(
  CafeteriaReminderNotifier.new,
);

class CafeteriaReminderNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle(bool value) {
    state = value;
  }
}