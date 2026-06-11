import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/home_local_datasource.dart';
import 'client_home_event.dart';
import 'client_home_state.dart';

class ClientHomeBloc extends Bloc<ClientHomeEvent, ClientHomeState> {
  ClientHomeBloc(this._dataSource) : super(const ClientHomeInitial()) {
    on<LoadProviders>(_onLoadProviders);
    on<ProviderSearchChanged>(_onProviderSearchChanged);
  }

  final HomeLocalDataSource _dataSource;

  Future<void> _onLoadProviders(
    LoadProviders event,
    Emitter<ClientHomeState> emit,
  ) async {
    await _loadProviders(event.searchQuery, emit);
  }

  Future<void> _onProviderSearchChanged(
    ProviderSearchChanged event,
    Emitter<ClientHomeState> emit,
  ) async {
    await _loadProviders(event.query, emit);
  }

  Future<void> _loadProviders(
    String searchQuery,
    Emitter<ClientHomeState> emit,
  ) async {
    emit(const ClientHomeLoading());
    try {
      final providers = await _dataSource.getCompleteProviders(
        specialtyQuery: searchQuery,
      );
      emit(ClientHomeLoaded(
        providers: providers,
        searchQuery: searchQuery.trim(),
      ));
    } catch (error) {
      emit(ClientHomeError(error.toString()));
    }
  }
}
