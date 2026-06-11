import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../core/session/auth_session.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/widgets/logout_button.dart';
import '../../../requests/domain/entities/request_status.dart';
import '../../../requests/domain/entities/service_request.dart';
import '../../../requests/domain/usecases/get_provider_requests.dart';
import '../../../requests/domain/usecases/update_request_status.dart';
import '../bloc/provider_home_bloc.dart';
import '../bloc/provider_home_event.dart';
import '../bloc/provider_home_state.dart';

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final providerId = GetIt.I<AuthSession>().user?.id;

    if (providerId == null) {
      return const Scaffold(
        body: Center(child: Text('Faça login como prestador para continuar.')),
      );
    }

    return BlocProvider(
      create: (_) => ProviderHomeBloc(
        getProviderRequests: GetIt.I<GetProviderRequests>(),
        updateRequestStatus: GetIt.I<UpdateRequestStatus>(),
        providerId: providerId,
      )..add(const LoadProviderRequests()),
      child: const _ProviderHomeView(),
    );
  }
}

class _ProviderHomeView extends StatelessWidget {
  const _ProviderHomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas solicitações'),
        actions: const [LogoutButton()],
      ),
      body: BlocBuilder<ProviderHomeBloc, ProviderHomeState>(
        builder: (context, state) {
          if (state is ProviderHomeLoaded) {
            if (state.requests.isEmpty) {
              return const _EmptyRequestsState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                return _RequestCard(request: state.requests[index]);
              },
            );
          }

          if (state is ProviderHomeError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(request.desiredDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Endereço: ${request.address}'),
            const SizedBox(height: AppSpacing.xs),
            Text('Data desejada: $date'),
            const SizedBox(height: AppSpacing.sm),
            Text(request.details),
            if (request.status.canAdvance) ...[
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    context.read<ProviderHomeBloc>().add(
                          AdvanceRequestStatusRequested(request),
                        );
                  },
                  child: Text(_nextActionLabel(request.status)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _nextActionLabel(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 'Iniciar trabalho';
      case RequestStatus.working:
        return 'Concluir solicitação';
      case RequestStatus.completed:
        return 'Concluído';
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(status.label));
  }
}

class _EmptyRequestsState extends StatelessWidget {
  const _EmptyRequestsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 48),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nenhuma solicitação ainda',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Quando um cliente enviar um pedido para você, ele aparecerá aqui.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
