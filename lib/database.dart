import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:progreso_corporal_app/widgets/metrics.dart';

final String tableHistorial = 'historial';
final String columnPeso = 'peso';
final String columnGrasa = 'grasa';
final String columnMusculo = 'musculo';
final String columnDate = 'date';
//final String columnImagen = 'imagen';

class HistorialDB {
  //static final HistorialDB db = HistorialDB();

  static Database _database;
  static HistorialDB _historialDB;

  HistorialDB._createInstance();
  factory HistorialDB() {
    if (_historialDB == null) {
      _historialDB = HistorialDB._createInstance();
    }
    return _historialDB;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "historial.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableHistorial ( 
          $columnPeso text, 
          $columnGrasa text,
          $columnMusculo text,
          $columnDate text primary key)
        ''');
      },
    );
    return database;
  }

  void insertData(Metrics metrics) async {
    var db = await database;
    var result = await db.insert(tableHistorial, metrics.toMap());
    print('resultado es $result');
  }

  Future<List<Metrics>> getHistorialData() async {
    List<Metrics> _alarms = [];

    var db = await this.database;
    var result = await db.query(tableHistorial);
    result.forEach((element) {
      var alarmInfo = Metrics.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db
        .delete(tableHistorial, where: '$columnDate = ?', whereArgs: [id]);
  }

  Future<int> update(Metrics metrics) async {
    var db = await this.database;
    return await db.update(tableHistorial, metrics.toMap(),
        where: '$columnDate = ?', whereArgs: [metrics.date]);
  }
}
