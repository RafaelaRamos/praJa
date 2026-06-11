import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/request_status.dart';
import '../entities/service_request.dart';
import '../repositories/request_repository.dart';

class UpdateRequestStatus {
  UpdateRequestStatus(this._repository);

  final RequestRepository _repository;

  Future<Either<Failure, ServiceRequest>> call({
    required String requestId,
    required RequestStatus status,
  }) {
    return _repository.updateRequestStatus(
      requestId: requestId,
      status: status,
    );
  }
}
