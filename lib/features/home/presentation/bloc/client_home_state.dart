import 'package:equatable/equatable.dart';

import '../../domain/entities/provider_list_item.dart';

abstract class ClientHomeState extends Equatable {
  const ClientHomeState();

  @override
  List<Object?> get props => [];
}

class ClientHomeInitial extends ClientHomeState {
  const ClientHomeInitial();
}

class ClientHomeLoading extends ClientHomeState {
  const ClientHomeLoading();
}

class ClientHomeLoaded extends ClientHomeState {
  const ClientHomeLoaded({
    required this.providers,
    this.searchQuery = '',
  });

  final List<ProviderListItem> providers;
  final String searchQuery;

  @override
  List<Object?> get props => [providers, searchQuery];
}

class ClientHomeError extends ClientHomeState {
  const ClientHomeError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
