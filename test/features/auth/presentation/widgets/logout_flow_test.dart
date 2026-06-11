import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:praja/core/database/database_helper.dart';
import 'package:praja/core/router/app_router.dart';
import 'package:praja/core/session/auth_session.dart';
import 'package:praja/features/auth/domain/entities/user.dart';
import 'package:praja/features/auth/domain/entities/user_type.dart';
import 'package:praja/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:praja/features/auth/presentation/bloc/auth_event.dart';
import 'package:praja/features/auth/presentation/bloc/auth_state.dart';
import 'package:praja/features/auth/presentation/pages/login_page.dart';
import 'package:praja/features/auth/presentation/widgets/logout_button.dart';
import 'package:praja/features/home/data/datasources/home_local_datasource.dart';
import 'package:praja/features/home/presentation/pages/client_home_page.dart';
import 'package:praja/features/home/presentation/pages/provider_home_page.dart';
import 'package:praja/features/requests/domain/usecases/get_provider_requests.dart';
import 'package:praja/features/requests/domain/usecases/update_request_status.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

class _MockGetProviderRequests extends Mock implements GetProviderRequests {}

class _MockUpdateRequestStatus extends Mock implements UpdateRequestStatus {}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await GetIt.I.reset();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    GetIt.I.registerSingleton<SharedPreferences>(prefs);
    GetIt.I.registerSingleton<DatabaseHelper>(DatabaseHelper(prefs));
    GetIt.I.registerSingleton<HomeLocalDataSource>(
      HomeLocalDataSource(GetIt.I<DatabaseHelper>()),
    );
    final authSession = AuthSession();
    GetIt.I.registerSingleton<AuthSession>(authSession);

    final getProviderRequests = _MockGetProviderRequests();
    when(() => getProviderRequests(any())).thenAnswer((_) async {
      return const Right([]);
    });
    GetIt.I.registerSingleton<GetProviderRequests>(getProviderRequests);
    GetIt.I.registerSingleton<UpdateRequestStatus>(
      _MockUpdateRequestStatus(),
    );
  });
  final clientUser = User(
    id: 'client-1',
    email: 'cliente@test.com',
    name: 'Cliente',
    cpf: '12345678901',
    birthDate: DateTime(1990, 1, 1),
    phone: '11999999999',
    userType: UserType.client,
  );

  final providerUser = User(
    id: 'provider-1',
    email: 'prestador@test.com',
    name: 'Prestador',
    cpf: '10987654321',
    birthDate: DateTime(1985, 5, 5),
    phone: '11988888888',
    userType: UserType.provider,
  );

  Widget wrapWithAuthBloc(Widget child, AuthBloc authBloc) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: child,
      ),
    );
  }

  testWidgets('LogoutButton dispatches LogoutSubmitted', (tester) async {
    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      wrapWithAuthBloc(const Scaffold(body: LogoutButton()), authBloc),
    );

    await tester.tap(find.text('Sair'));
    await tester.pump();

    verify(() => authBloc.add(const LogoutSubmitted())).called(1);
  });

  testWidgets('ClientHomePage shows Sair button', (tester) async {
    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      wrapWithAuthBloc(const ClientHomePage(), authBloc),
    );

    expect(find.text('Sair'), findsOneWidget);
  });

  testWidgets('ProviderHomePage shows Sair button', (tester) async {
    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());
    GetIt.I<AuthSession>().setUser(providerUser);

    await tester.pumpWidget(
      wrapWithAuthBloc(const ProviderHomePage(), authBloc),
    );

    expect(find.text('Sair'), findsOneWidget);
  });

  Widget wrapWithRouter(AuthSession authSession, AuthBloc authBloc) {
    GetIt.I<AuthSession>().setUser(authSession.user);

    return BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: MaterialApp.router(
        routerConfig: createAppRouter(authSession),
      ),
    );
  }

  testWidgets('router redirects to login when session is cleared', (tester) async {
    final authSession = AuthSession();
    authSession.setUser(clientUser);

    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(wrapWithRouter(authSession, authBloc));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Prestadores disponíveis'), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);

    authSession.setUser(null);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Entrar no praJa'), findsOneWidget);
  });

  testWidgets('authenticated provider is redirected away from login', (tester) async {
    final authSession = AuthSession();
    authSession.setUser(providerUser);

    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(wrapWithRouter(authSession, authBloc));
    await tester.pumpAndSettle();

    expect(find.text('Minhas solicitações'), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });
}
