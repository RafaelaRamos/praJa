import '../../domain/entities/request_status.dart';
import '../../domain/entities/service_request.dart';

class ServiceRequestModel {
  ServiceRequestModel({
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

  factory ServiceRequestModel.fromMap(Map<String, Object?> map) {
    return ServiceRequestModel(
      id: map['id']! as String,
      clientId: map['client_id']! as String,
      providerId: map['provider_id']! as String,
      title: map['title']! as String,
      address: map['address']! as String,
      details: map['details']! as String,
      desiredDate: DateTime.parse(map['desired_date']! as String),
      status: RequestStatus.fromString(map['status']! as String),
      createdAt: DateTime.parse(map['created_at']! as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'provider_id': providerId,
      'title': title,
      'address': address,
      'details': details,
      'desired_date': desiredDate.toIso8601String().split('T').first,
      'status': status.value,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  ServiceRequest toEntity() {
    return ServiceRequest(
      id: id,
      clientId: clientId,
      providerId: providerId,
      title: title,
      address: address,
      details: details,
      desiredDate: desiredDate,
      status: status,
      createdAt: createdAt,
    );
  }
}
