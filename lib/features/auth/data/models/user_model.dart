import '../../domain/entities/user.dart';
import '../../domain/entities/user_type.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.cpf,
    required this.birthDate,
    required this.phone,
    required this.userType,
    required this.profileComplete,
  });

  final String id;
  final String email;
  final String name;
  final String cpf;
  final DateTime birthDate;
  final String phone;
  final UserType userType;
  final bool profileComplete;

  factory UserModel.fromMap(Map<String, Object?> map) {
    return UserModel(
      id: map['id']! as String,
      email: map['email']! as String,
      name: map['name']! as String,
      cpf: map['cpf']! as String,
      birthDate: DateTime.parse(map['birth_date']! as String),
      phone: map['phone']! as String,
      userType: UserType.fromString(map['user_type']! as String),
      profileComplete: (map['profile_complete'] as int? ?? 1) == 1,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      cpf: cpf,
      birthDate: birthDate,
      phone: phone,
      userType: userType,
      profileComplete: profileComplete,
    );
  }
}
