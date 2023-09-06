import 'package:classinsights/models/user_role.dart';

class AuthData {
  final String name;
  final String id;
  final String email;
  final Role role;
  final String schoolClass;
  final String headTeacher;
  final DateTime expirationDate;

  const AuthData({
    required this.name,
    required this.id,
    required this.email,
    required this.role,
    required this.schoolClass,
    required this.headTeacher,
    required this.expirationDate,
  });

  static AuthData blank() {
    return AuthData(
      name: "",
      id: "",
      email: "",
      role: Role.student,
      schoolClass: "",
      headTeacher: "",
      expirationDate: DateTime.now(),
    );
  }
}
