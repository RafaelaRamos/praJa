import 'package:sqflite/sqflite.dart';

Future<void> runMigrations(
  Database db,
  int version, {
  int fromVersion = 0,
}) async {
  if (version >= 1 && fromVersion < 1) {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        name TEXT NOT NULL,
        cpf TEXT NOT NULL,
        birth_date TEXT NOT NULL,
        phone TEXT NOT NULL,
        user_type TEXT NOT NULL CHECK(user_type IN ('client', 'provider')),
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE provider_profiles (
        user_id TEXT PRIMARY KEY,
        profession TEXT NOT NULL,
        specialty TEXT NOT NULL,
        address TEXT NOT NULL,
        description TEXT NOT NULL,
        is_complete INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  if (version >= 2 && fromVersion < 2) {
    await db.execute('''
      CREATE TABLE service_requests (
        id TEXT PRIMARY KEY,
        client_id TEXT NOT NULL,
        provider_id TEXT NOT NULL,
        title TEXT NOT NULL,
        address TEXT NOT NULL,
        details TEXT NOT NULL,
        desired_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending'
          CHECK(status IN ('pending', 'working', 'completed')),
        created_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (provider_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }
}
