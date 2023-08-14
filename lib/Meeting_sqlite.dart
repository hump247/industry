import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';

class MeetingHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
          CREATE TABLE IF NOT EXISTS Meetings(
            id INTEGER PRIMARY KEY,
            Start_Meeting TEXT,
            Venue TEXT,
            Date TEXT,
            Time TEXT,
            Agenda TEXT,
            Discussion TEXT,
            Name TEXT,
            Responsibilities TEXT,
            Time_frame TEXT,
            Conclusion TEXT, 
            End_Meeting TEXT
          )
        """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'Meeting.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createMetting(
      String start_time,
      String? venue,
      String date,
      String? time,
      String? agenda,
      String discussion,
      String name,
      String responsibility,
      String? timeframe,
      String? conclusion,
      String end_time

      ) async {
    final db = await MeetingHelper.db();
    final data = {
      'start_time': start_time,
      'venue': venue,
      'date': date,
      'time': time,
      'agenda': agenda,
      'discussion': discussion,
      'name': name,
      'responsibility': responsibility,
      'timeframe': timeframe,
      'conclusion': conclusion,
      'end_time':end_time
    };
    final id = await db.insert(
      'Meetings',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await MeetingHelper.db();
    return db.query('Meetings', orderBy: "id");
  }

  static Future<int> updateItem(
      String start_time,
      String venue,
      String date,
      String time,
      String agenda,
      String discussion,
      String name,
      String responsibility,
      String timeframe,
      String conclusion,
      String end_time,
      ) async {
    final db = await MeetingHelper.db();
    final data = {
      'start_time': start_time,
      'venue': venue,
      'date': date,
      'time': time,
      'agenda': agenda,
      'discussion': discussion,
      'name': name,
      'responsibility': responsibility,
      'timeframe': timeframe,
      'conclusion': conclusion,
      'end_time':end_time
    };
    final result = await db.update(
      'Meetings',
      data,
      where: "id = ?",

    );
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await MeetingHelper.db();
    try {
      await db.delete("Meetings", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
