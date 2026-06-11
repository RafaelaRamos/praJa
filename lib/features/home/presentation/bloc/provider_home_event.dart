import 'package:equatable/equatable.dart';

import '../../../requests/domain/entities/service_request.dart';

abstract class ProviderHomeEvent extends Equatable {
  const ProviderHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadProviderRequests extends ProviderHomeEvent {
  const LoadProviderRequests();
}

class AdvanceRequestStatusRequested extends ProviderHomeEvent {
  const AdvanceRequestStatusRequested(this.request);

  final ServiceRequest request;

  @override
  List<Object?> get props => [request];
}
