import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar dados locais']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Falha de autenticação']);
}
