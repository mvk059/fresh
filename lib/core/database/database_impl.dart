import 'package:fresh/core/database/database_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseImpl implements DatabaseInterface {

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fresh.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE coordinates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        synced INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table, {String? where}) async {
    final db = await database;
    return await db.query(table, where: where);
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String where)  async {
    final db = await database;
    return await db.update(table, data, where: where);
  }

  @override
  Future<int> delete(String table, String where) async {
    final db = await database;
    return await db.delete(table, where: where);
  }

}