import 'package:equatable/equatable.dart';

import 'request_status.dart';

class ServiceRequest extends Equatable {
  const ServiceRequest({
    required this.id,
    required this.clientId,
    required this.providerId,
    required this.title,
    required this.address,
    required this.details,
    required this.desiredDate,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String clientId;
  final String providerId;
  final String title;
  final String address;
  final String details;
  final DateTime desiredDate;
  final RequestStatus status;
  final DateTime createdAt;

  ServiceRequest copyWith({
    String? id,
    String? clientId,
    String? providerId,
    String? title,
    String? address,
    String? details,
    DateTime? desiredDate,
    RequestStatus? status,
    DateTime? createdAt,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      address: address ?? this.address,
      details: details ?? this.details,
      desiredDate: desiredDate ?? this.desiredDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        providerId,
        title,
        address,
        details,
        desiredDate,
        status,
        createdAt,
      ];
}
