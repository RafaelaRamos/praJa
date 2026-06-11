import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<AuthBloc>().add(const LogoutSubmitted()),
      child: const Text('Sair'),
    );
  }
}
