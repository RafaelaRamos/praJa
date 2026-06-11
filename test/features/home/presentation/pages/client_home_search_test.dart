import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:praja/core/database/database_helper.dart';
import 'package:praja/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:praja/features/auth/presentation/bloc/auth_state.dart';
import 'package:praja/features/home/data/datasources/home_local_datasource.dart';
import 'package:praja/features/home/presentation/pages/client_home_page.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

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
  });

  testWidgets('ClientHomePage shows specialty search field', (tester) async {
    final authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthInitial());
    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const ClientHomePage(),
        ),
      ),
    );

    expect(find.text('Buscar por especialidade'), findsOneWidget);
  });
}
