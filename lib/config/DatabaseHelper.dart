import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;

  // Future<Database> get database async => db ??= await createDatabase();

  Map<int, String> migrationsScript = {
    1: """ CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        date DATE NOT NULL,
        description TEXT NOT NULL
      );
    """,
    2: """ CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY,
        todo_name TEXT NOT NULL,
        todo_finish INT DEFAULT 0
      ); """,
    3: """
    ALTER TABLE todos  ADD note_id INTEGER;
     """,
  };

  Future<Database> get database async => _database ??= await createDatabase();
  createDatabase() async {
    String path = await getPath();
    int migrationLength = migrationsScript.length;

    if (_database == null) {
      _database = await openDatabase(
        path,
        version: migrationLength,
        onCreate: (Database db, int version) async {
          for (int i = 1; i <= migrationLength; i++) {
            await db.execute("${migrationsScript[i]}");
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          for (int i = oldVersion + 1; i <= newVersion; i++) {
            await db.execute("${migrationsScript[i]}");
          }
        },
      );
    }
    return _database;
  }

  Future<String> getPath() async {
    var databasePath = await getDatabasesPath();

    String path = join(databasePath, 'notes.db');

    return path;
  }

  Future _createDB(Database db) async {}

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("""
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        date DATE NOT NULL,
        description TEXT NOT NULL
      );
    """);

    await db.execute("""
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        todo_name TEXT NOT NULL,
        todo_finish INT DEFAULT 0,
      );
    """);

    await db.close();
  }
}
