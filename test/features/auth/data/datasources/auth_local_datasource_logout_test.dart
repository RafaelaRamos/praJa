import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:praja/core/database/database_helper.dart';
import 'package:praja/features/auth/data/datasources/auth_local_datasource.dart';

class _MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  test('logout removes current_user_id from SharedPreferences', () async {
    SharedPreferences.setMockInitialValues({
      currentUserIdKey: 'user-123',
    });

    final prefs = await SharedPreferences.getInstance();
    final dataSource = AuthLocalDataSource(_MockDatabaseHelper(), prefs);

    expect(prefs.getString(currentUserIdKey), 'user-123');

    await dataSource.logout();

    expect(prefs.getString(currentUserIdKey), isNull);
  });
}
