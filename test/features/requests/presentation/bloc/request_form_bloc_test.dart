import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:praja/core/error/failures.dart';
import 'package:praja/features/requests/domain/entities/request_status.dart';
import 'package:praja/features/requests/domain/entities/service_request.dart';
import 'package:praja/features/requests/domain/usecases/create_service_request.dart';
import 'package:praja/features/requests/presentation/bloc/request_form_bloc.dart';
import 'package:praja/features/requests/presentation/bloc/request_form_event.dart';
import 'package:praja/features/requests/presentation/bloc/request_form_state.dart';

class _MockCreateServiceRequest extends Mock implements CreateServiceRequest {}

void main() {
  late _MockCreateServiceRequest createServiceRequest;

  final createdRequest = ServiceRequest(
    id: 'req-1',
    clientId: 'client-1',
    providerId: 'provider-1',
    title: 'Trocar tomada',
    address: 'Rua A, 10',
    details: 'Detalhes',
    desiredDate: DateTime(2026, 7, 1),
    status: RequestStatus.pending,
    createdAt: DateTime(2026, 6, 7),
  );

  setUp(() {
    createServiceRequest = _MockCreateServiceRequest();
  });

  blocTest<RequestFormBloc, RequestFormState>(
    'emits success when request is created',
    build: () {
      when(
        () => createServiceRequest(
          clientId: any(named: 'clientId'),
          providerId: any(named: 'providerId'),
          title: any(named: 'title'),
          address: any(named: 'address'),
          details: any(named: 'details'),
          desiredDate: any(named: 'desiredDate'),
        ),
      ).thenAnswer((_) async => Right(createdRequest));

      return RequestFormBloc(
        createServiceRequest: createServiceRequest,
        clientId: 'client-1',
        providerId: 'provider-1',
      );
    },
    act: (bloc) => bloc.add(
      RequestFormSubmitted(
        title: 'Trocar tomada',
        address: 'Rua A, 10',
        details: 'Detalhes',
        desiredDate: DateTime(2026, 7, 1),
      ),
    ),
    expect: () => [const RequestFormSubmitting(), const RequestFormSuccess()],
  );

  blocTest<RequestFormBloc, RequestFormState>(
    'emits error when request creation fails',
    build: () {
      when(
        () => createServiceRequest(
          clientId: any(named: 'clientId'),
          providerId: any(named: 'providerId'),
          title: any(named: 'title'),
          address: any(named: 'address'),
          details: any(named: 'details'),
          desiredDate: any(named: 'desiredDate'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ValidationFailure('Preencha título, endereço e detalhes para continuar.'),
        ),
      );

      return RequestFormBloc(
        createServiceRequest: createServiceRequest,
        clientId: 'client-1',
        providerId: 'provider-1',
      );
    },
    act: (bloc) => bloc.add(
      RequestFormSubmitted(
        title: '',
        address: 'Rua A, 10',
        details: 'Detalhes',
        desiredDate: DateTime(2026, 7, 1),
      ),
    ),
    expect: () => [
      const RequestFormSubmitting(),
      const RequestFormError(
        'Preencha título, endereço e detalhes para continuar.',
      ),
    ],
  );
}
