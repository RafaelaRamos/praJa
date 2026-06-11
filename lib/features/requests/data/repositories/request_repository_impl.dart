import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/request_status.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_local_datasource.dart';

class RequestRepositoryImpl implements RequestRepository {
  RequestRepositoryImpl(this._localDataSource);

  final RequestLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, ServiceRequest>> createRequest({
    required String clientId,
    required String providerId,
    required String title,
    required String address,
    required String details,
    required DateTime desiredDate,
  }) async {
    try {
      final model = await _localDataSource.createRequest(
        clientId: clientId,
        providerId: providerId,
        title: title,
        address: address,
        details: details,
        desiredDate: desiredDate,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceRequest>>> getRequestsForProvider(
    String providerId,
  ) async {
    try {
      final models = await _localDataSource.getRequestsForProvider(providerId);
      return Right(models.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceRequest>> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
  }) async {
    try {
      final model = await _localDataSource.updateRequestStatus(
        requestId: requestId,
        status: status,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(CacheFailure(error.toString()));
    }
  }
}
