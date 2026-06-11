import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/password_hasher.dart';
import '../../domain/entities/provider_profile.dart';
import '../../domain/entities/user_type.dart';
import '../models/user_model.dart';

const currentUserIdKey = 'current_user_id';

class AuthLocalDataSource {
  AuthLocalDataSource(this._databaseHelper, this._prefs);

  final DatabaseHelper _databaseHelper;
  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required DateTime birthDate,
    required String phone,
    required UserType userType,
    ProviderProfile? providerProfile,
  }) async {
    _validateRegistration(
      email: email,
      password: password,
      name: name,
      cpf: cpf,
      phone: phone,
    );

    final db = await _databaseHelper.database;
    final normalizedEmail = email.trim().toLowerCase();
    final digitsCpf = _digitsOnly(cpf);

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw const ValidationFailure('Este email já está cadastrado.');
    }

    final userId = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();

    await db.insert('users', {
      'id': userId,
      'email': normalizedEmail,
      'password_hash': hashPassword(password),
      'name': name.trim(),
      'cpf': digitsCpf,
      'birth_date': birthDate.toIso8601String().split('T').first,
      'phone': _digitsOnly(phone),
      'user_type': userType.value,
      'created_at': now,
    });

    var profileComplete = true;

    if (userType == UserType.provider) {
      final profile = providerProfile;
      final isComplete = profile != null && profile.isValid;

      await db.insert('provider_profiles', {
        'user_id': userId,
        'profession': profile?.profession.trim() ?? '',
        'specialty': profile?.specialty.trim() ?? '',
        'address': profile?.address.trim() ?? '',
        'description': profile?.description.trim() ?? '',
        'is_complete': isComplete ? 1 : 0,
      });

      profileComplete = isComplete;
    }

    if (profileComplete) {
      await _prefs.setString(currentUserIdKey, userId);
    }

    return UserModel(
      id: userId,
      email: normalizedEmail,
      name: name.trim(),
      cpf: digitsCpf,
      birthDate: birthDate,
      phone: _digitsOnly(phone),
      userType: userType,
      profileComplete: profileComplete,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final db = await _databaseHelper.database;
    final normalizedEmail = email.trim().toLowerCase();

    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw const AuthFailure(
        'Email ou senha incorretos. Verifique os dados e tente novamente.',
      );
    }

    final row = rows.first;
    final storedHash = row['password_hash'] as String;

    if (storedHash != hashPassword(password)) {
      throw const AuthFailure(
        'Email ou senha incorretos. Verifique os dados e tente novamente.',
      );
    }

    final userId = row['id']! as String;
    final userType = UserType.fromString(row['user_type']! as String);
    var profileComplete = true;

    if (userType == UserType.provider) {
      final profileRows = await db.query(
        'provider_profiles',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      profileComplete = profileRows.isNotEmpty &&
          (profileRows.first['is_complete'] as int? ?? 0) == 1;

      if (!profileComplete) {
        throw const AuthFailure(
          'Complete seu perfil profissional antes de entrar.',
        );
      }
    }

    await _prefs.setString(currentUserIdKey, userId);

    return UserModel.fromMap({
      ...row,
      'profile_complete': profileComplete ? 1 : 0,
    });
  }

  Future<UserModel?> getCurrentUser() async {
    final userId = _prefs.getString(currentUserIdKey);
    if (userId == null) {
      return null;
    }

    final db = await _databaseHelper.database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) {
      await _prefs.remove(currentUserIdKey);
      return null;
    }

    final row = rows.first;
    final userType = UserType.fromString(row['user_type']! as String);
    var profileComplete = true;

    if (userType == UserType.provider) {
      final profileRows = await db.query(
        'provider_profiles',
        where: 'user_id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      profileComplete = profileRows.isNotEmpty &&
          (profileRows.first['is_complete'] as int? ?? 0) == 1;
    }

    return UserModel.fromMap({
      ...row,
      'profile_complete': profileComplete ? 1 : 0,
    });
  }

  Future<void> logout() async {
    await _prefs.remove(currentUserIdKey);
  }

  void _validateRegistration({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required String phone,
  }) {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        cpf.trim().isEmpty ||
        phone.trim().isEmpty) {
      throw const ValidationFailure(
        'Preencha todos os campos obrigatórios para continuar.',
      );
    }

    if (!_isValidEmail(email)) {
      throw const ValidationFailure(
        'Informe um email válido (exemplo@email.com).',
      );
    }

    if (password.length < 6) {
      throw const ValidationFailure(
        'A senha deve ter no mínimo 6 caracteres.',
      );
    }

    if (_digitsOnly(cpf).length != 11) {
      throw const ValidationFailure('CPF inválido. Verifique os 11 dígitos.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email.trim());
  }

  String _digitsOnly(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }
}
