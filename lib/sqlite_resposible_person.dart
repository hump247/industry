import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class SQLHelper1 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
          CREATE TABLE IF NOT EXISTS responsible_persons(
            id INTEGER PRIMARY KEY,
            name TEXT,
            agenda TEXT,
            responsibility TEXT,
            timeframe TEXT
          )
        """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech2.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem1(
      String name,
      String? agenda,
      String responsibility,
      String? timeframe,
      ) async {
    final db = await SQLHelper1.db();
    final data = {
      'name': name,
      'agenda': agenda,
      'responsibility': responsibility,
      'timeframe': timeframe,
    };
    final id = await db.insert(
      'responsible_persons',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper1.db();
    return db.query('responsible_persons', orderBy: "id");
  }

  static Future<int> updateItem(
      int id,
      String name,
      String? agenda,
      String responsibility,
      String? timeframe,
      ) async {
    final db = await SQLHelper1.db();
    final data = {
      'name': name,
      'agenda': agenda,
      'responsibility': responsibility,
      'timeframe': timeframe,
      'createdAt': DateTime.now().toString(),
    };
    final result = await db.update(
      'responsible_persons',
      data,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper1.db();
    try {
      await db.delete("responsible_persons", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
