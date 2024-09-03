import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'duty_type.dart';
import 'duty.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseName = 'emregggggg2.db';

  static const _databaseVersion = 1;
  static const tableDuty = 'duty_table';
  static const tableType = 'type_table';
  static const dutyId = 'id';
  static const dutyTypeId = 'typeId';

  static const typeId = 'id';
  static const typeName = 'name';

  static const dutyName = 'name';
  static const dutySituation = 'situation';

  static Future<Database> get getDatabaseInstance async {
    Database? database;

    database ??= await _initDatabase();

    return database;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onConfigure: _onConfigure);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $tableDuty (
      $dutyId INTEGER PRIMARY KEY AUTOINCREMENT,
      $dutyName TEXT NOT NULL, 
      $dutySituation INTEGER NOT NULL,
      $dutyTypeId INTEGER NOT NULL,
      FOREIGN KEY (typeId) REFERENCES type_table(id)      
                  )''');
    await db.execute(''' CREATE TABLE $tableType (
      $typeId INTEGER PRIMARY KEY AUTOINCREMENT,
      $typeName TEXT NOT NULL      
    )''');
  }

  static Future<int> insertDuty(Duty duty) async {
    Database db = await _initDatabase();

    return await db.insert(tableDuty, duty.toJson());
  }

  static Future<int> deleteDuty(int id) async {
    Database db = await _initDatabase();

    return await db.delete(tableDuty, where: '$dutyId = ?', whereArgs: [id]);
  }

  static Future<int> updateDutyState(bool? value, Duty duty) async {
    Database db = await _initDatabase();

    int id = duty.id;
    duty.isCompleted = value!;

    final data = duty.toJson();

    return await db.update(tableDuty, data, where: 'id =?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> queryAllDuties() async {
    Database db = await _initDatabase();

    return await db.query(tableDuty);
  }

  static Future<int> insertDutyType(DutyType type) async {
    Database db = await _initDatabase();

    return await db.insert(tableType, type.toJson());
  }

  static Future<int> deleteDutyType(int? id) async {
    Database db = await _initDatabase();

    return await db.delete(tableType, where: '$typeId = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> queryAllDutyTypes() async {
    Database db = await _initDatabase();

    return await db.query(tableType);
  }
}
