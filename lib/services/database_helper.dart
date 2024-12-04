import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async =>
      await TodoDb().createTable(database);
}

class TodoDb {
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP
      );
      """);
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await DatabaseHelper().database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await DatabaseHelper().database;
    return await db.query('todos', orderBy: 'id DESC');
  }

  Future<int> updateData(int id, String title, String description) async {
    try {
      final db = await DatabaseHelper().database;

      if (title.isEmpty || description.isEmpty) {
        throw ArgumentError("Parameters can not be empty.");
      }

      final data = {
        'title': title,
        'description': description,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final result =
          await db.update(tableName, data, where: "id=?", whereArgs: [id]);

      return result;
    } catch (e) {
      print("Update error: $e");
      return -1;
    }
  }

  Future<bool> deleteData(int id) async {
    final db = await DatabaseHelper().database;

    try {
      final result = await db.delete(tableName, where: "id=?", whereArgs: [id]);
      if (result > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Delete error: $e");
      return false;
    }
  }
}
