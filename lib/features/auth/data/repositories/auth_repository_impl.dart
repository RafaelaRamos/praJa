import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/provider_profile.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_type.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required DateTime birthDate,
    required String phone,
    required UserType userType,
    ProviderProfile? providerProfile,
  }) async {
    try {
      final model = await _localDataSource.register(
        email: email,
        password: password,
        name: name,
        cpf: cpf,
        birthDate: birthDate,
        phone: phone,
        userType: userType,
        providerProfile: providerProfile,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _localDataSource.login(
        email: email,
        password: password,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final model = await _localDataSource.getCurrentUser();
      return Right(model?.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<void> logout() {
    return _localDataSource.logout();
  }
}
