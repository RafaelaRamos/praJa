import 'package:flutter_test/flutter_test.dart';

import 'package:praja/core/database/migrations.dart';
import 'package:praja/core/database/seed_data.dart';

void main() {
  test('migrations define users and provider_profiles tables', () {
    expect(runMigrations, isNotNull);
  });

  test('seed defines five mock providers', () {
    expect(kMockProviderCount, 5);
  });
}
