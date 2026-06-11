import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../session/auth_session.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/client_home_page.dart';
import '../../features/home/presentation/pages/provider_home_page.dart';
import '../../features/requests/presentation/pages/request_form_page.dart';

GoRouter createAppRouter(AuthSession authSession) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authSession,
    redirect: (context, state) {
      if (authSession.isLoading) {
        return null;
      }

      final user = authSession.user;
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' || location == '/register';

      if (user == null) {
        return isAuthRoute ? null : '/login';
      }

      if (user.isClient) {
        if (location.startsWith('/client-home')) {
          return null;
        }
        return '/client-home';
      }

      return location == '/provider-home' ? null : '/provider-home';
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/client-home',
        builder: (context, state) => const ClientHomePage(),
        routes: [
          GoRoute(
            path: 'request/:providerId',
            builder: (context, state) {
              final providerId = state.pathParameters['providerId']!;
              return RequestFormPage(providerId: providerId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/provider-home',
        builder: (context, state) => const ProviderHomePage(),
      ),
    ],
  );
}

class AuthLoadingPage extends StatelessWidget {
  const AuthLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
