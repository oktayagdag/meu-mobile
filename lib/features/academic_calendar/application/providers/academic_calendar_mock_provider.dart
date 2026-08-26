import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meu_mobile/features/academic_calendar/domain/entities/academic_calendar_item_entity.dart';

final selectedAcademicTermProvider =
    NotifierProvider<SelectedAcademicTermNotifier, AcademicTerm>(
      SelectedAcademicTermNotifier.new,
    );

class SelectedAcademicTermNotifier extends Notifier<AcademicTerm> {
  @override
  AcademicTerm build() {
    return AcademicTerm.fall;
  }

  void select(AcademicTerm term) {
    state = term;
  }
}

final fallAcademicCalendarItemsProvider = Provider<List<AcademicCalendarItemEntity>>((
  ref,
) {
  return const [
    AcademicCalendarItemEntity(
      title:
          'Kayıt Yenileme (Ders Kaydı) ve Katkı Payı/Öğrenim Ücretlerinin Yatırılması',
      startDate: '07.09.2026',
      endDate: '13.09.2026',
    ),
    AcademicCalendarItemEntity(
      title: 'Danışman Onayı',
      startDate: '07.09.2026',
      endDate: '21.09.2026',
    ),
    AcademicCalendarItemEntity(
      title: 'Ders Kaydı Değişikliği (Ekle-Sil) ve Mazeretli Ders Kaydı',
      startDate: '14.09.2026',
      endDate: '18.09.2026',
    ),
    AcademicCalendarItemEntity(
      title: 'Eğitim Öğretim Dönemi (Derslerin Başlangıcı ve Bitişi)',
      startDate: '14.09.2026',
      endDate: '30.12.2026',
    ),
    AcademicCalendarItemEntity(
      title: 'Ara Sınavlar',
      startDate: '07.11.2026',
      endDate: '15.11.2026',
    ),
    AcademicCalendarItemEntity(
      title:
          'Ara Sınavlar ve Dönem İçi Faaliyet Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '07.11.2026',
      endDate: '30.12.2026',
    ),
    AcademicCalendarItemEntity(
      title: 'Yarıyıl Sonu Sınavları',
      startDate: '02.01.2027',
      endDate: '17.01.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Yarıyıl Sonu Sınav Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '02.01.2027',
      endDate: '20.01.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Bütünleme Sınavları',
      startDate: '23.01.2027',
      endDate: '31.01.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Bütünleme Sınav Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '23.01.2027',
      endDate: '03.02.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Tek Ders Sınavları',
      startDate: '04.02.2027',
      endDate: '05.02.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Tek Ders Sınavlarının Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '04.02.2027',
      endDate: '05.02.2027',
    ),
  ];
});

final springAcademicCalendarItemsProvider = Provider<List<AcademicCalendarItemEntity>>((
  ref,
) {
  return const [
    AcademicCalendarItemEntity(
      title:
          'Kayıt Yenileme (Ders Kaydı) ve Katkı Payı/Öğrenim Ücretlerinin Yatırılması',
      startDate: '01.02.2027',
      endDate: '07.02.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Danışman Onayı',
      startDate: '01.02.2027',
      endDate: '15.02.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Ders Kaydı Değişikliği (Ekle-Sil) ve Mazeretli Ders Kaydı (Kayıt Yenileme)',
      startDate: '08.02.2027',
      endDate: '12.02.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Eğitim Öğretim Dönemi (Derslerin Başlangıcı ve Bitişi)',
      startDate: '08.02.2027',
      endDate: '07.06.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Ara Sınavlar',
      startDate: '03.04.2027',
      endDate: '11.04.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Ara Sınavlar ve Dönem İçi Faaliyet Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '03.04.2027',
      endDate: '07.06.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Yarıyıl Sonu Sınavları',
      startDate: '08.06.2027',
      endDate: '20.06.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Yarıyıl Sonu Sınav Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '08.06.2027',
      endDate: '23.06.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Bütünleme Sınavları',
      startDate: '26.06.2027',
      endDate: '04.07.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Bütünleme Sınav Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '26.06.2027',
      endDate: '07.07.2027',
    ),
    AcademicCalendarItemEntity(
      title: 'Tek Ders Sınavları',
      startDate: '08.07.2027',
      endDate: '09.07.2027',
    ),
    AcademicCalendarItemEntity(
      title:
          'Tek Ders Sınavlarının Sonuçlarının Girişi ve İnternet Ortamında İlanı',
      startDate: '08.07.2027',
      endDate: '09.07.2027',
    ),
  ];
});

final selectedAcademicCalendarItemsProvider =
    Provider<List<AcademicCalendarItemEntity>>((ref) {
      final selectedTerm = ref.watch(selectedAcademicTermProvider);

      switch (selectedTerm) {
        case AcademicTerm.fall:
          return ref.watch(fallAcademicCalendarItemsProvider);
        case AcademicTerm.spring:
          return ref.watch(springAcademicCalendarItemsProvider);
      }
    });
