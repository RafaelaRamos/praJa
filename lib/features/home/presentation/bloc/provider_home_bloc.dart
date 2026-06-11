import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../requests/domain/usecases/get_provider_requests.dart';
import '../../../requests/domain/usecases/update_request_status.dart';
import 'provider_home_event.dart';
import 'provider_home_state.dart';

class ProviderHomeBloc extends Bloc<ProviderHomeEvent, ProviderHomeState> {
  ProviderHomeBloc({
    required GetProviderRequests getProviderRequests,
    required UpdateRequestStatus updateRequestStatus,
    required String providerId,
  })  : _getProviderRequests = getProviderRequests,
        _updateRequestStatus = updateRequestStatus,
        _providerId = providerId,
        super(const ProviderHomeInitial()) {
    on<LoadProviderRequests>(_onLoadProviderRequests);
    on<AdvanceRequestStatusRequested>(_onAdvanceRequestStatusRequested);
  }

  final GetProviderRequests _getProviderRequests;
  final UpdateRequestStatus _updateRequestStatus;
  final String _providerId;

  Future<void> _onLoadProviderRequests(
    LoadProviderRequests event,
    Emitter<ProviderHomeState> emit,
  ) async {
    await _loadRequests(emit);
  }

  Future<void> _onAdvanceRequestStatusRequested(
    AdvanceRequestStatusRequested event,
    Emitter<ProviderHomeState> emit,
  ) async {
    final nextStatus = event.request.status.next;
    final result = await _updateRequestStatus(
      requestId: event.request.id,
      status: nextStatus,
    );

    await result.fold(
      (failure) async => emit(ProviderHomeError(failure.message)),
      (_) => _loadRequests(emit),
    );
  }

  Future<void> _loadRequests(Emitter<ProviderHomeState> emit) async {
    emit(const ProviderHomeLoading());

    final result = await _getProviderRequests(_providerId);
    result.fold(
      (failure) => emit(ProviderHomeError(failure.message)),
      (requests) => emit(ProviderHomeLoaded(requests)),
    );
  }
}
