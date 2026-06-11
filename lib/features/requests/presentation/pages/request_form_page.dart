import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/data/datasources/home_local_datasource.dart';
import '../../../home/domain/entities/provider_list_item.dart';
import '../../domain/usecases/create_service_request.dart';
import '../bloc/request_form_bloc.dart';
import '../bloc/request_form_event.dart';
import '../bloc/request_form_state.dart';

class RequestFormPage extends StatefulWidget {
  const RequestFormPage({super.key, required this.providerId});

  final String providerId;

  @override
  State<RequestFormPage> createState() => _RequestFormPageState();
}

class _RequestFormPageState extends State<RequestFormPage> {
  ProviderListItem? _provider;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadProvider();
  }

  Future<void> _loadProvider() async {
    try {
      final provider = await GetIt.I<HomeLocalDataSource>()
          .getProviderById(widget.providerId);
      if (!mounted) return;

      if (provider == null) {
        setState(() => _loadError = 'Prestador não encontrado.');
        return;
      }

      setState(() => _provider = provider);
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadError = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova solicitação')),
        body: Center(child: Text(_loadError!)),
      );
    }

    if (_provider == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova solicitação')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final authSession = GetIt.I<AuthSession>();
    final clientId = authSession.user?.id;

    if (clientId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova solicitação')),
        body: const Center(
          child: Text('Faça login como cliente para enviar uma solicitação.'),
        ),
      );
    }

    return BlocProvider(
      create: (_) => RequestFormBloc(
        createServiceRequest: GetIt.I<CreateServiceRequest>(),
        clientId: clientId,
        providerId: widget.providerId,
      ),
      child: _RequestFormView(provider: _provider!),
    );
  }
}

class _RequestFormView extends StatefulWidget {
  const _RequestFormView({required this.provider});

  final ProviderListItem provider;

  @override
  State<_RequestFormView> createState() => _RequestFormViewState();
}

class _RequestFormViewState extends State<_RequestFormView> {
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailsController = TextEditingController();
  DateTime? _desiredDate;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _desiredDate == null
        ? 'Selecionar data'
        : DateFormat('dd/MM/yyyy').format(_desiredDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar ${widget.provider.name}'),
      ),
      body: SafeArea(
        child: BlocConsumer<RequestFormBloc, RequestFormState>(
          listener: (context, state) {
            if (state is RequestFormError) {
              setState(() => _errorMessage = state.message);
            }

            if (state is RequestFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitação enviada com sucesso.'),
                ),
              );
              context.pop();
            }
          },
          builder: (context, state) {
            final isSubmitting = state is RequestFormSubmitting;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.provider.specialty,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Título da solicitação',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Endereço do serviço',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _detailsController,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Detalhes do serviço',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: isSubmitting ? null : _pickDesiredDate,
                    child: Text('Data desejada: $dateLabel'),
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
                    onPressed: isSubmitting ? null : () => _submit(isSubmitting),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Enviar solicitação'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickDesiredDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _desiredDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      setState(() => _desiredDate = picked);
    }
  }

  void _submit(bool isSubmitting) {
    if (isSubmitting) return;

    if (_desiredDate == null) {
      setState(() => _errorMessage = 'Selecione a data desejada para continuar.');
      return;
    }

    setState(() => _errorMessage = null);
    context.read<RequestFormBloc>().add(
          RequestFormSubmitted(
            title: _titleController.text,
            address: _addressController.text,
            details: _detailsController.text,
            desiredDate: _desiredDate!,
          ),
        );
  }
}
