import 'package:equatable/equatable.dart';

abstract class RequestFormEvent extends Equatable {
  const RequestFormEvent();

  @override
  List<Object?> get props => [];
}

class RequestFormSubmitted extends RequestFormEvent {
  const RequestFormSubmitted({
    required this.title,
    required this.address,
    required this.details,
    required this.desiredDate,
  });

  final String title;
  final String address;
  final String details;
  final DateTime desiredDate;

  @override
  List<Object?> get props => [title, address, details, desiredDate];
}
