import 'package:equatable/equatable.dart';

import 'user_type.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.cpf,
    required this.birthDate,
    required this.phone,
    required this.userType,
    this.profileComplete = true,
  });

  final String id;
  final String email;
  final String name;
  final String cpf;
  final DateTime birthDate;
  final String phone;
  final UserType userType;
  final bool profileComplete;

  bool get isClient => userType == UserType.client;
  bool get isProvider => userType == UserType.provider;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        cpf,
        birthDate,
        phone,
        userType,
        profileComplete,
      ];
}
