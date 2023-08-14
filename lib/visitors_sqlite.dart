import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper2 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
          CREATE TABLE discussion (
          id INTEGER PRIMARY KEY,
          discussion TEXT
)
        """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech3.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem1(
      String discussion,
      ) async {
    final db = await SQLHelper2.db();
    final data = {
      'discussion': discussion,

    };
    final id = await db.insert(
      'discussion',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper2.db();
    return db.query('discussion', orderBy: "id");
  }

  static Future<int> updateItem(
      int id,
      String discussion,

      ) async {
    final db = await SQLHelper2.db();
    final data = {
      'discussion': discussion,

    };
    final result = await db.update(
      'discussion',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper2.db();
    try {
      await db.delete("discussion", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
