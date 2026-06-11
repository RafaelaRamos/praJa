import 'package:equatable/equatable.dart';

abstract class ClientHomeEvent extends Equatable {
  const ClientHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadProviders extends ClientHomeEvent {
  const LoadProviders({this.searchQuery = ''});

  final String searchQuery;

  @override
  List<Object?> get props => [searchQuery];
}

class ProviderSearchChanged extends ClientHomeEvent {
  const ProviderSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
