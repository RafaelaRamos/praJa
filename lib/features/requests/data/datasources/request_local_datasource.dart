import 'package:uuid/uuid.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../models/service_request_model.dart';
import '../../domain/entities/request_status.dart';

class RequestLocalDataSource {
  RequestLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;
  static const _uuid = Uuid();

  Future<ServiceRequestModel> createRequest({
    required String clientId,
    required String providerId,
    required String title,
    required String address,
    required String details,
    required DateTime desiredDate,
  }) async {
    _validateRequest(
      title: title,
      address: address,
      details: details,
    );

    final db = await _databaseHelper.database;

    final providerRows = await db.query(
      'users',
      where: 'id = ? AND user_type = ?',
      whereArgs: [providerId, 'provider'],
      limit: 1,
    );

    if (providerRows.isEmpty) {
      throw const ValidationFailure('Prestador não encontrado.');
    }

    final profileRows = await db.query(
      'provider_profiles',
      where: 'user_id = ? AND is_complete = 1',
      whereArgs: [providerId],
      limit: 1,
    );

    if (profileRows.isEmpty) {
      throw const ValidationFailure('Prestador indisponível para solicitações.');
    }

    final id = _uuid.v4();
    final now = DateTime.now().toUtc();

    final model = ServiceRequestModel(
      id: id,
      clientId: clientId,
      providerId: providerId,
      title: title.trim(),
      address: address.trim(),
      details: details.trim(),
      desiredDate: desiredDate,
      status: RequestStatus.pending,
      createdAt: now,
    );

    await db.insert('service_requests', model.toMap());
    return model;
  }

  Future<List<ServiceRequestModel>> getRequestsForProvider(
    String providerId,
  ) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'service_requests',
      where: 'provider_id = ?',
      whereArgs: [providerId],
      orderBy: 'created_at DESC',
    );

    return rows.map(ServiceRequestModel.fromMap).toList();
  }

  Future<ServiceRequestModel> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
  }) async {
    final db = await _databaseHelper.database;
    final updated = await db.update(
      'service_requests',
      {'status': status.value},
      where: 'id = ?',
      whereArgs: [requestId],
    );

    if (updated == 0) {
      throw const ValidationFailure('Solicitação não encontrada.');
    }

    final rows = await db.query(
      'service_requests',
      where: 'id = ?',
      whereArgs: [requestId],
      limit: 1,
    );

    return ServiceRequestModel.fromMap(rows.first);
  }

  void _validateRequest({
    required String title,
    required String address,
    required String details,
  }) {
    if (title.trim().isEmpty ||
        address.trim().isEmpty ||
        details.trim().isEmpty) {
      throw const ValidationFailure(
        'Preencha título, endereço e detalhes para continuar.',
      );
    }
  }
}
