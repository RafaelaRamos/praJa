import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations.dart';
import 'seed_data.dart';

const _dbName = 'praja.db';
const _dbVersion = 2;
const _seededKey = 'db_seeded';

class DatabaseHelper {
  DatabaseHelper(this._prefs);

  final SharedPreferences _prefs;
  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }

    final db = await _initDatabase();
    _database = db;
    return db;
  }

  Future<Database> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), _dbName);

    final db = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (database, version) async {
        await runMigrations(database, version);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        await runMigrations(
          database,
          newVersion,
          fromVersion: oldVersion,
        );
      },
    );

    await _seedIfNeeded(db);
    return db;
  }

  Future<void> _seedIfNeeded(Database db) async {
    if (_prefs.getBool(_seededKey) ?? false) {
      return;
    }

    await seedMockProviders(db);
    await _prefs.setBool(_seededKey, true);
  }

  Future<int> countProviders() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM users WHERE user_type = 'provider'
    ''');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
