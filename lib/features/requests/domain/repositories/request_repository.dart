import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/request_status.dart';
import '../entities/service_request.dart';

abstract class RequestRepository {
  Future<Either<Failure, ServiceRequest>> createRequest({
    required String clientId,
    required String providerId,
    required String title,
    required String address,
    required String details,
    required DateTime desiredDate,
  });

  Future<Either<Failure, List<ServiceRequest>>> getRequestsForProvider(
    String providerId,
  );

  Future<Either<Failure, ServiceRequest>> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
  });
}
