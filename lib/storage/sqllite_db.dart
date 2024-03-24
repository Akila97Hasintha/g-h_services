import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

 static Future<Database> initDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'gallery.db');
  final database = await openDatabase(path, version: 1, onCreate: _createDatabase);
  _createDatabase(database, 1); // Ensure table creation
  return database;
}


static void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS offline_request (
        id INTEGER PRIMARY KEY,
        activityType TEXT,
        imagePath TEXT,
        remarks TEXT,
        location TEXT
        
      )
    ''');
  }

  static Future<int> insertFormData(Map<String, dynamic> formData) async {
    final db = await database;
     formData['location'] = json.encode(formData['location']);
     Fluttertoast.showToast(
                      msg: " insert Data===local :",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,);
    return db.insert('offline_request', formData);

  }

  static Future<List<Map<String, dynamic>>> getFormData() async {
    final db = await database;
    return db.query('offline_request');
  }


  static Future<int> deleteFormData(int id) async {
    final db = await database;
    return db.delete('offline_request', where: 'id = ?', whereArgs: [id]);
  }
  static Future<void> deleteTable(String tableName) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }


}
