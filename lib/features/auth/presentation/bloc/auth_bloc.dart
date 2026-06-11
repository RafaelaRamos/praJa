import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/auth_session.dart';
import '../../domain/entities/provider_profile.dart';
import '../../domain/entities/user_type.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RegisterUser registerUser,
    required LoginUser loginUser,
    required GetCurrentUser getCurrentUser,
    required LogoutUser logoutUser,
    required AuthSession authSession,
  })  : _registerUser = registerUser,
        _loginUser = loginUser,
        _getCurrentUser = getCurrentUser,
        _logoutUser = logoutUser,
        _authSession = authSession,
        super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  final RegisterUser _registerUser;
  final LoginUser _loginUser;
  final GetCurrentUser _getCurrentUser;
  final LogoutUser _logoutUser;
  final AuthSession _authSession;

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    _authSession.setLoading(true);

    final result = await _getCurrentUser();
    result.fold(
      (failure) {
        _authSession.setUser(null);
        emit(AuthError(failure.message));
      },
      (user) {
        _authSession.setUser(user);
        if (user == null) {
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthAuthenticated(user));
        }
      },
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUser(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        _authSession.setUser(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    ProviderProfile? profile = event.providerProfile;

    final result = await _registerUser(
      email: event.email,
      password: event.password,
      name: event.name,
      cpf: event.cpf,
      birthDate: event.birthDate,
      phone: event.phone,
      userType: event.isProvider ? UserType.provider : UserType.client,
      providerProfile: profile,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (user.profileComplete) {
          _authSession.setUser(user);
          emit(AuthAuthenticated(user));
        } else {
          _authSession.setUser(null);
          emit(const AuthRegistrationSuccess(requiresLogin: true));
        }
      },
    );
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUser();
    _authSession.setUser(null);
    emit(const AuthUnauthenticated());
  }
}
