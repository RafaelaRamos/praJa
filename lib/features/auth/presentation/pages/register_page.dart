import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../domain/entities/provider_profile.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/provider_profile_sheet.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isProvider = false;
  DateTime? _birthDate;
  ProviderProfile? _providerProfile;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/login')),
      ),
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

            if (state is AuthRegistrationSuccess && state.requiresLogin) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Conta criada. Complete seu perfil profissional e faça login.',
                  ),
                ),
              );
              context.go('/login');
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final dateLabel = _birthDate == null
                ? 'Selecionar data'
                : DateFormat('dd/MM/yyyy').format(_birthDate!);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Criar sua conta',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CpfInputFormatter()],
                    decoration: const InputDecoration(labelText: 'CPF'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () => _pickBirthDate(context),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Data de nascimento: $dateLabel'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneInputFormatter()],
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    textInputAction: TextInputAction.next,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sou prestador de serviço'),
                    value: _isProvider,
                    onChanged: (value) async {
                      setState(() => _isProvider = value);
                      if (value) {
                        final profile = await ProviderProfileSheet.show(context);
                        setState(() => _providerProfile = profile);
                      } else {
                        setState(() => _providerProfile = null);
                      }
                    },
                  ),
                  if (_isProvider && _providerProfile != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        'Perfil profissional preenchido: ${_providerProfile!.specialty}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  FilledButton(
                    onPressed: isLoading ? null : () => _submit(isLoading),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Criar conta'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Já tem conta? Entrar na conta'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _submit(bool isLoading) {
    if (isLoading) return;

    if (_birthDate == null) {
      setState(() {
        _errorMessage =
            'Preencha todos os campos obrigatórios para continuar.';
      });
      return;
    }

    setState(() => _errorMessage = null);
    context.read<AuthBloc>().add(
          RegisterSubmitted(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            cpf: _cpfController.text,
            birthDate: _birthDate!,
            phone: _phoneController.text,
            isProvider: _isProvider,
            providerProfile: _providerProfile,
          ),
        );
  }
}
