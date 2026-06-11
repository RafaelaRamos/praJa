import 'package:equatable/equatable.dart';

import '../../domain/entities/provider_profile.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  const RegisterSubmitted({
    required this.email,
    required this.password,
    required this.name,
    required this.cpf,
    required this.birthDate,
    required this.phone,
    required this.isProvider,
    this.providerProfile,
  });

  final String email;
  final String password;
  final String name;
  final String cpf;
  final DateTime birthDate;
  final String phone;
  final bool isProvider;
  final ProviderProfile? providerProfile;

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        cpf,
        birthDate,
        phone,
        isProvider,
        providerProfile,
      ];
}

class LogoutSubmitted extends AuthEvent {
  const LogoutSubmitted();
}
