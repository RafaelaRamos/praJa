import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/service_request.dart';
import '../repositories/request_repository.dart';

class GetProviderRequests {
  GetProviderRequests(this._repository);

  final RequestRepository _repository;

  Future<Either<Failure, List<ServiceRequest>>> call(String providerId) {
    return _repository.getRequestsForProvider(providerId);
  }
}
