import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:praja/core/session/auth_session.dart';
import 'package:praja/features/auth/domain/entities/user.dart';
import 'package:praja/features/auth/domain/entities/user_type.dart';
import 'package:praja/features/auth/domain/usecases/get_current_user.dart';
import 'package:praja/features/auth/domain/usecases/login_user.dart';
import 'package:praja/features/auth/domain/usecases/logout_user.dart';
import 'package:praja/features/auth/domain/usecases/register_user.dart';
import 'package:praja/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:praja/features/auth/presentation/bloc/auth_event.dart';
import 'package:praja/features/auth/presentation/bloc/auth_state.dart';

class _MockRegisterUser extends Mock implements RegisterUser {}

class _MockLoginUser extends Mock implements LoginUser {}

class _MockGetCurrentUser extends Mock implements GetCurrentUser {}

class _MockLogoutUser extends Mock implements LogoutUser {}

void main() {
  late _MockRegisterUser registerUser;
  late _MockLoginUser loginUser;
  late _MockGetCurrentUser getCurrentUser;
  late _MockLogoutUser logoutUser;
  late AuthSession authSession;

  final testUser = User(
    id: 'user-1',
    email: 'cliente@test.com',
    name: 'Cliente Teste',
    cpf: '12345678901',
    birthDate: DateTime(1990, 1, 1),
    phone: '11999999999',
    userType: UserType.client,
  );

  AuthBloc buildBloc() {
    return AuthBloc(
      registerUser: registerUser,
      loginUser: loginUser,
      getCurrentUser: getCurrentUser,
      logoutUser: logoutUser,
      authSession: authSession,
    );
  }

  setUp(() {
    registerUser = _MockRegisterUser();
    loginUser = _MockLoginUser();
    getCurrentUser = _MockGetCurrentUser();
    logoutUser = _MockLogoutUser();
    authSession = AuthSession();
    authSession.setUser(testUser);

    when(() => logoutUser()).thenAnswer((_) async {});
  });

  blocTest<AuthBloc, AuthState>(
    'clears session and emits AuthUnauthenticated on LogoutSubmitted',
    build: buildBloc,
    act: (bloc) => bloc.add(const LogoutSubmitted()),
    expect: () => [const AuthUnauthenticated()],
    verify: (_) {
      verify(() => logoutUser()).called(1);
      expect(authSession.user, isNull);
    },
  );
}
