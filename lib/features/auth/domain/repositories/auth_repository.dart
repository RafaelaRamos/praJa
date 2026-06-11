import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/provider_profile.dart';
import '../entities/user.dart';
import '../entities/user_type.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required DateTime birthDate,
    required String phone,
    required UserType userType,
    ProviderProfile? providerProfile,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User?>> getCurrentUser();

  Future<void> logout();
}
