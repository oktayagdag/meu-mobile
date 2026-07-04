class UserProfileEntity {
  const UserProfileEntity({
    required this.fullName,
    required this.department,
    required this.studentNumber,
    required this.email,
    required this.initials,
  });

  final String fullName;
  final String department;
  final String studentNumber;
  final String email;
  final String initials;
}

class ProfileStatEntity {
  const ProfileStatEntity({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;
}