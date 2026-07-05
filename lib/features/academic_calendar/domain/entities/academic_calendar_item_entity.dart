enum AcademicTerm {
  fall,
  spring,
}

extension AcademicTermX on AcademicTerm {
  String get label {
    switch (this) {
      case AcademicTerm.fall:
        return 'Güz';
      case AcademicTerm.spring:
        return 'Bahar';
    }
  }
}

class AcademicCalendarItemEntity {
  const AcademicCalendarItemEntity({
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  final String title;
  final String startDate;
  final String endDate;
}