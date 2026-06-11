import '../../../../core/database/database_helper.dart';
import '../../domain/entities/provider_list_item.dart';

class HomeLocalDataSource {
  HomeLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  Future<List<ProviderListItem>> getCompleteProviders({
    String specialtyQuery = '',
  }) async {
    final db = await _databaseHelper.database;
    final trimmedQuery = specialtyQuery.trim();

    final rows = trimmedQuery.isEmpty
        ? await db.rawQuery('''
      SELECT u.id, u.name, p.specialty
      FROM users u
      INNER JOIN provider_profiles p ON p.user_id = u.id
      WHERE u.user_type = 'provider' AND p.is_complete = 1
      ORDER BY u.name ASC
    ''')
        : await db.rawQuery(
            '''
      SELECT u.id, u.name, p.specialty
      FROM users u
      INNER JOIN provider_profiles p ON p.user_id = u.id
      WHERE u.user_type = 'provider'
        AND p.is_complete = 1
        AND LOWER(p.specialty) LIKE LOWER(?)
      ORDER BY u.name ASC
    ''',
            ['%$trimmedQuery%'],
          );

    return rows
        .map(
          (row) => ProviderListItem(
            id: row['id']! as String,
            name: row['name']! as String,
            specialty: row['specialty']! as String,
          ),
        )
        .toList();
  }

  Future<ProviderListItem?> getProviderById(String providerId) async {
    final db = await _databaseHelper.database;
    final rows = await db.rawQuery(
      '''
      SELECT u.id, u.name, p.specialty
      FROM users u
      INNER JOIN provider_profiles p ON p.user_id = u.id
      WHERE u.id = ? AND u.user_type = 'provider' AND p.is_complete = 1
      LIMIT 1
    ''',
      [providerId],
    );

    if (rows.isEmpty) {
      return null;
    }

    final row = rows.first;
    return ProviderListItem(
      id: row['id']! as String,
      name: row['name']! as String,
      specialty: row['specialty']! as String,
    );
  }
}
