import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:praja/features/home/data/datasources/home_local_datasource.dart';
import 'package:praja/features/home/domain/entities/provider_list_item.dart';
import 'package:praja/features/home/presentation/bloc/client_home_bloc.dart';
import 'package:praja/features/home/presentation/bloc/client_home_event.dart';
import 'package:praja/features/home/presentation/bloc/client_home_state.dart';

class _MockHomeLocalDataSource extends Mock implements HomeLocalDataSource {}

void main() {
  late _MockHomeLocalDataSource dataSource;

  const providers = [
    ProviderListItem(
      id: '1',
      name: 'Roberto Lima',
      specialty: 'Pintor',
    ),
  ];

  setUp(() {
    dataSource = _MockHomeLocalDataSource();
  });

  blocTest<ClientHomeBloc, ClientHomeState>(
    'loads filtered providers when search changes',
    build: () {
      when(
        () => dataSource.getCompleteProviders(specialtyQuery: 'pint'),
      ).thenAnswer((_) async => providers);

      return ClientHomeBloc(dataSource);
    },
    act: (bloc) => bloc.add(const ProviderSearchChanged('pint')),
    expect: () => [
      const ClientHomeLoading(),
      const ClientHomeLoaded(
        providers: providers,
        searchQuery: 'pint',
      ),
    ],
    verify: (_) {
      verify(
        () => dataSource.getCompleteProviders(specialtyQuery: 'pint'),
      ).called(1);
    },
  );

  blocTest<ClientHomeBloc, ClientHomeState>(
    'loads all providers on initial load',
    build: () {
      when(() => dataSource.getCompleteProviders(specialtyQuery: ''))
          .thenAnswer((_) async => providers);

      return ClientHomeBloc(dataSource);
    },
    act: (bloc) => bloc.add(const LoadProviders()),
    expect: () => [
      const ClientHomeLoading(),
      const ClientHomeLoaded(providers: providers),
    ],
  );
}
