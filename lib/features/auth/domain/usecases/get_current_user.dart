import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  GetCurrentUser(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User?>> call() {
    return _repository.getCurrentUser();
  }
}
