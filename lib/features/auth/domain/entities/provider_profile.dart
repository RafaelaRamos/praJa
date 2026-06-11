import 'package:equatable/equatable.dart';

class ProviderProfile extends Equatable {
  const ProviderProfile({
    required this.profession,
    required this.specialty,
    required this.address,
    required this.description,
    required this.isComplete,
  });

  final String profession;
  final String specialty;
  final String address;
  final String description;
  final bool isComplete;

  bool get isValid =>
      profession.trim().isNotEmpty &&
      specialty.trim().isNotEmpty &&
      address.trim().isNotEmpty &&
      description.trim().isNotEmpty;

  @override
  List<Object?> get props =>
      [profession, specialty, address, description, isComplete];
}
