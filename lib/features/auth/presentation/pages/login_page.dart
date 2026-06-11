import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              setState(() => _errorMessage = state.message);
            }

            if (state is AuthAuthenticated) {
              final route =
                  state.user.isClient ? '/client-home' : '/provider-home';
              context.go(route);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'praJa',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Entrar no praJa',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    onSubmitted: (_) => _submit(isLoading),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: isLoading ? null : () => _submit(isLoading),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar na conta'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Não tem conta? Criar conta'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit(bool isLoading) {
    if (isLoading) return;

    setState(() => _errorMessage = null);
    context.read<AuthBloc>().add(
          LoginSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        );
  }
}
