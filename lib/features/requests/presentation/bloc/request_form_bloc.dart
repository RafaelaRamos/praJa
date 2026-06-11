import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_service_request.dart';
import 'request_form_event.dart';
import 'request_form_state.dart';

class RequestFormBloc extends Bloc<RequestFormEvent, RequestFormState> {
  RequestFormBloc({
    required CreateServiceRequest createServiceRequest,
    required String clientId,
    required String providerId,
  })  : _createServiceRequest = createServiceRequest,
        _clientId = clientId,
        _providerId = providerId,
        super(const RequestFormInitial()) {
    on<RequestFormSubmitted>(_onSubmitted);
  }

  final CreateServiceRequest _createServiceRequest;
  final String _clientId;
  final String _providerId;

  Future<void> _onSubmitted(
    RequestFormSubmitted event,
    Emitter<RequestFormState> emit,
  ) async {
    emit(const RequestFormSubmitting());

    final result = await _createServiceRequest(
      clientId: _clientId,
      providerId: _providerId,
      title: event.title,
      address: event.address,
      details: event.details,
      desiredDate: event.desiredDate,
    );

    result.fold(
      (failure) => emit(RequestFormError(failure.message)),
      (_) => emit(const RequestFormSuccess()),
    );
  }
}
