import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:praja/features/home/presentation/bloc/provider_home_bloc.dart';
import 'package:praja/features/home/presentation/bloc/provider_home_event.dart';
import 'package:praja/features/home/presentation/bloc/provider_home_state.dart';
import 'package:praja/features/requests/domain/entities/request_status.dart';
import 'package:praja/features/requests/domain/entities/service_request.dart';
import 'package:praja/features/requests/domain/usecases/get_provider_requests.dart';
import 'package:praja/features/requests/domain/usecases/update_request_status.dart';

class _MockGetProviderRequests extends Mock implements GetProviderRequests {}

class _MockUpdateRequestStatus extends Mock implements UpdateRequestStatus {}

void main() {
  late _MockGetProviderRequests getProviderRequests;
  late _MockUpdateRequestStatus updateRequestStatus;

  final pendingRequest = ServiceRequest(
    id: 'request-1',
    clientId: 'client-1',
    providerId: 'provider-1',
    title: 'Trocar tomada',
    address: 'Rua A, 10',
    details: 'Tomada da cozinha parou de funcionar.',
    desiredDate: DateTime(2026, 7, 1),
    status: RequestStatus.pending,
    createdAt: DateTime(2026, 6, 8),
  );

  ProviderHomeBloc buildBloc() {
    return ProviderHomeBloc(
      getProviderRequests: getProviderRequests,
      updateRequestStatus: updateRequestStatus,
      providerId: 'provider-1',
    );
  }

  setUp(() {
    getProviderRequests = _MockGetProviderRequests();
    updateRequestStatus = _MockUpdateRequestStatus();
  });

  blocTest<ProviderHomeBloc, ProviderHomeState>(
    'loads provider requests',
    build: () {
      when(() => getProviderRequests('provider-1')).thenAnswer(
        (_) async => Right([pendingRequest]),
      );

      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoadProviderRequests()),
    expect: () => [
      const ProviderHomeLoading(),
      ProviderHomeLoaded([pendingRequest]),
    ],
  );

  blocTest<ProviderHomeBloc, ProviderHomeState>(
    'advances pending request to working and reloads list',
    build: () {
      final workingRequest = pendingRequest.copyWith(
        status: RequestStatus.working,
      );

      when(
        () => updateRequestStatus(
          requestId: 'request-1',
          status: RequestStatus.working,
        ),
      ).thenAnswer((_) async => Right(workingRequest));

      when(() => getProviderRequests('provider-1')).thenAnswer(
        (_) async => Right([workingRequest]),
      );

      return buildBloc();
    },
    act: (bloc) => bloc.add(AdvanceRequestStatusRequested(pendingRequest)),
    expect: () => [
      const ProviderHomeLoading(),
      ProviderHomeLoaded([
        pendingRequest.copyWith(status: RequestStatus.working),
      ]),
    ],
  );
}
