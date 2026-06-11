import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/widgets/logout_button.dart';
import '../../data/datasources/home_local_datasource.dart';
import '../bloc/client_home_bloc.dart';
import '../bloc/client_home_event.dart';
import '../bloc/client_home_state.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientHomeBloc(
        GetIt.I<HomeLocalDataSource>(),
      )..add(const LoadProviders()),
      child: const _ClientHomeView(),
    );
  }
}

class _ClientHomeView extends StatefulWidget {
  const _ClientHomeView();

  @override
  State<_ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<_ClientHomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestadores disponíveis'),
        actions: const [LogoutButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscar por especialidade',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ClientHomeBloc>().add(ProviderSearchChanged(value));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ClientHomeBloc, ClientHomeState>(
              builder: (context, state) {
                if (state is ClientHomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ClientHomeError) {
                  return Center(child: Text(state.message));
                }

                if (state is ClientHomeLoaded && state.providers.isEmpty) {
                  return _EmptyProvidersState(
                    hasSearchQuery: state.searchQuery.isNotEmpty,
                  );
                }

                if (state is ClientHomeLoaded) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.providers.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final provider = state.providers[index];
                      final initial = provider.name.isNotEmpty
                          ? provider.name[0].toUpperCase()
                          : '?';

                      return Card(
                        child: ListTile(
                          minVerticalPadding: 16,
                          leading: CircleAvatar(child: Text(initial)),
                          title: Text(provider.name),
                          subtitle: Text(provider.specialty),
                          onTap: () => context.push(
                            '/client-home/request/${provider.id}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.message_outlined),
                            tooltip: 'Mensagem',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProvidersState extends StatelessWidget {
  const _EmptyProvidersState({required this.hasSearchQuery});

  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearchQuery ? Icons.search_off : Icons.person_search,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              hasSearchQuery
                  ? 'Nenhum prestador encontrado'
                  : 'Nenhum prestador disponível',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasSearchQuery
                  ? 'Tente outra especialidade ou limpe a busca para ver todos os prestadores.'
                  : 'Ainda não há profissionais cadastrados. Volte em breve ou cadastre-se como prestador.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
