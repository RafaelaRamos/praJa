import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:praja/core/error/failures.dart';
import 'package:praja/features/requests/data/datasources/request_local_datasource.dart';
import 'package:praja/features/requests/data/models/service_request_model.dart';
import 'package:praja/features/requests/data/repositories/request_repository_impl.dart';
import 'package:praja/features/requests/domain/entities/request_status.dart';

class _MockRequestLocalDataSource extends Mock implements RequestLocalDataSource {}

void main() {
  late _MockRequestLocalDataSource dataSource;
  late RequestRepositoryImpl repository;

  final model = ServiceRequestModel(
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
    dataSource = _MockRequestLocalDataSource();
    repository = RequestRepositoryImpl(dataSource);
  });

  test('returns created request entity on success', () async {
    when(
      () => dataSource.createRequest(
        clientId: any(named: 'clientId'),
        providerId: any(named: 'providerId'),
        title: any(named: 'title'),
        address: any(named: 'address'),
        details: any(named: 'details'),
        desiredDate: any(named: 'desiredDate'),
      ),
    ).thenAnswer((_) async => model);

    final result = await repository.createRequest(
      clientId: 'client-1',
      providerId: 'provider-1',
      title: 'Trocar tomada',
      address: 'Rua A, 10',
      details: 'Detalhes',
      desiredDate: DateTime(2026, 7, 1),
    );

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected success'),
      (request) {
        expect(request.id, 'req-1');
        expect(request.status, RequestStatus.pending);
      },
    );
  });

  test('maps validation failure from datasource', () async {
    when(
      () => dataSource.createRequest(
        clientId: any(named: 'clientId'),
        providerId: any(named: 'providerId'),
        title: any(named: 'title'),
        address: any(named: 'address'),
        details: any(named: 'details'),
        desiredDate: any(named: 'desiredDate'),
      ),
    ).thenThrow(const ValidationFailure('Campos obrigatórios'));

    final result = await repository.createRequest(
      clientId: 'client-1',
      providerId: 'provider-1',
      title: '',
      address: 'Rua A, 10',
      details: 'Detalhes',
      desiredDate: DateTime(2026, 7, 1),
    );

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure.message, 'Campos obrigatórios'),
      (_) => fail('expected failure'),
    );
  });

  test('returns provider requests from datasource', () async {
    when(() => dataSource.getRequestsForProvider('provider-1')).thenAnswer(
      (_) async => [model],
    );

    final result = await repository.getRequestsForProvider('provider-1');

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected success'),
      (requests) {
        expect(requests, hasLength(1));
        expect(requests.first.providerId, 'provider-1');
      },
    );
  });

  test('updates request status through datasource', () async {
    final updatedModel = ServiceRequestModel(
      id: model.id,
      clientId: model.clientId,
      providerId: model.providerId,
      title: model.title,
      address: model.address,
      details: model.details,
      desiredDate: model.desiredDate,
      status: RequestStatus.working,
      createdAt: model.createdAt,
    );

    when(
      () => dataSource.updateRequestStatus(
        requestId: 'req-1',
        status: RequestStatus.working,
      ),
    ).thenAnswer((_) async => updatedModel);

    final result = await repository.updateRequestStatus(
      requestId: 'req-1',
      status: RequestStatus.working,
    );

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected success'),
      (request) => expect(request.status, RequestStatus.working),
    );
  });
}
