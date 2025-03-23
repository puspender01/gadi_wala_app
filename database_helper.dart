import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vehicles.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        registration_number TEXT UNIQUE,
        insurance_details TEXT,
        insurance_expiry TEXT,
        pucc_expiry TEXT,
        registration_date TEXT,
        service_date TEXT,
        photo_path TEXT
      )
    ''');
  }

  Future<int> addVehicle(Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.insert('vehicles', vehicle);
  }

  Future<int> updateVehicle(int id, Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.update('vehicles', vehicle, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteVehicle(int id) async {
    final db = await database;
    return await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query('vehicles');
  }
}
