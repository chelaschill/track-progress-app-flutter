import 'package:sqflite/sqflite.dart';

final String tableHistorial = 'historial';
final String columnPeso = 'peso';
final String columnGrasa = 'grasa';
final String columnMusculo = 'musculo';
final String columnFecha = 'fecha';
final String columnImagen = 'imagen';

class DataBase {
  static Database _database;
  static DataBase _dataBase;

  Future<Database> get database async {
    if (_database != null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  DataBase._createInstance();
  factory DataBase() {
    if (_dataBase == null) {
      _dataBase = DataBase._createInstance();
    }
    return _dataBase;
  }

  initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "historial.db";

    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
          create table $tableHistorial(
          $columnFecha DateTime primary key,
          $columnPeso text,
          $columnGrasa text,
          $columnMusculo text)
          ''');
    });
    return database;
  }
}
