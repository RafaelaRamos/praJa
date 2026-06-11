import 'package:equatable/equatable.dart';

import '../../../requests/domain/entities/service_request.dart';

abstract class ProviderHomeState extends Equatable {
  const ProviderHomeState();

  @override
  List<Object?> get props => [];
}

class ProviderHomeInitial extends ProviderHomeState {
  const ProviderHomeInitial();
}

class ProviderHomeLoading extends ProviderHomeState {
  const ProviderHomeLoading();
}

class ProviderHomeLoaded extends ProviderHomeState {
  const ProviderHomeLoaded(this.requests);

  final List<ServiceRequest> requests;

  @override
  List<Object?> get props => [requests];
}

class ProviderHomeError extends ProviderHomeState {
  const ProviderHomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
