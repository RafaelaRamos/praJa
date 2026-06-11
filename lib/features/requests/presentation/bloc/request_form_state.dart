import 'package:equatable/equatable.dart';

abstract class RequestFormState extends Equatable {
  const RequestFormState();

  @override
  List<Object?> get props => [];
}

class RequestFormInitial extends RequestFormState {
  const RequestFormInitial();
}

class RequestFormSubmitting extends RequestFormState {
  const RequestFormSubmitting();
}

class RequestFormSuccess extends RequestFormState {
  const RequestFormSuccess();
}

class RequestFormError extends RequestFormState {
  const RequestFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
