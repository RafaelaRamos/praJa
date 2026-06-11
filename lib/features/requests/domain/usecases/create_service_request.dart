import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/service_request.dart';
import '../repositories/request_repository.dart';

class CreateServiceRequest {
  CreateServiceRequest(this._repository);

  final RequestRepository _repository;

  Future<Either<Failure, ServiceRequest>> call({
    required String clientId,
    required String providerId,
    required String title,
    required String address,
    required String details,
    required DateTime desiredDate,
  }) {
    return _repository.createRequest(
      clientId: clientId,
      providerId: providerId,
      title: title,
      address: address,
      details: details,
      desiredDate: desiredDate,
    );
  }
}
