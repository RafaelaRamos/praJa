import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/provider_profile.dart';
import '../entities/user.dart';
import '../entities/user_type.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required DateTime birthDate,
    required String phone,
    required UserType userType,
    ProviderProfile? providerProfile,
  }) {
    return _repository.register(
      email: email,
      password: password,
      name: name,
      cpf: cpf,
      birthDate: birthDate,
      phone: phone,
      userType: userType,
      providerProfile: providerProfile,
    );
  }
}
