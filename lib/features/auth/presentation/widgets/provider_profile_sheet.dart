import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/provider_profile.dart';

class ProviderProfileSheet extends StatefulWidget {
  const ProviderProfileSheet({super.key});

  static Future<ProviderProfile?> show(BuildContext context) {
    return showModalBottomSheet<ProviderProfile?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const ProviderProfileSheet(),
    );
  }

  @override
  State<ProviderProfileSheet> createState() => _ProviderProfileSheetState();
}

class _ProviderProfileSheetState extends State<ProviderProfileSheet> {
  final _professionController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _professionController.dispose();
    _specialtyController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Dados profissionais',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _professionController,
              decoration: const InputDecoration(labelText: 'Profissão'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _specialtyController,
              decoration: const InputDecoration(labelText: 'Especialidade'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Endereço'),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () {
                final profile = ProviderProfile(
                  profession: _professionController.text,
                  specialty: _specialtyController.text,
                  address: _addressController.text,
                  description: _descriptionController.text,
                  isComplete: true,
                );

                if (!profile.isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Preencha todos os campos profissionais para continuar.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(context).pop(profile);
              },
              child: const Text('Salvar perfil profissional'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Continuar depois'),
            ),
          ],
        ),
      ),
    );
  }
}
