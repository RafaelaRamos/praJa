import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'core/session/auth_session.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

class PraJaApp extends StatelessWidget {
  const PraJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GetIt.I<GoRouter>();
    final authSession = GetIt.I<AuthSession>();

    return BlocProvider(
      create: (_) => GetIt.I<AuthBloc>(),
      child: ListenableBuilder(
        listenable: authSession,
        builder: (context, _) {
          if (authSession.isLoading) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp.router(
            title: 'praJa',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: router,
          );
        },
      ),
    );
  }
}
