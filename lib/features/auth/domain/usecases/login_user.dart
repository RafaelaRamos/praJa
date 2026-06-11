import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  LoginUser(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
