import 'package:progreso_corporal_app/historial.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:progreso_corporal_app/widgets/metrics.dart';
import 'package:path/path.dart' as p;

final String tableHistorial = 'historial';
final String columnDateString = 'dateString';
final String columnPeso = 'peso';
final String columnGrasa = 'grasa';
final String columnMusculo = 'musculo';
final String columnDate = 'date';
final String columnImagen = 'imageName';

class HistorialDB {
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
    String path = p.join(dir, "historial.db");
    //var path = dir + "historial.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableHistorial ( 
          $columnPeso text, 
          $columnGrasa text,
          $columnMusculo text,
          $columnDate text,
          $columnImagen text,
          $columnDateString text primary key)
        ''');
      },
    );
    return database;
  }

  Future<int> insertData(Metrics metrics) async {
    var db = await database;
    return await db.insert(tableHistorial, metrics.toMap());
  }

  Future<List<Metrics>> getHistorialData() async {
    List<Metrics> _historial = [];

    var db = await this.database;
    var result = await db.query(tableHistorial);
    result.forEach((element) {
      var alarmInfo = Metrics.fromMap(element);
      _historial.add(alarmInfo);
    });
    return _historial;
  }

  Future<int> delete(Metrics metrics) async {
    var db = await this.database;
    return await db.delete(tableHistorial,
        where: '$columnDate = ?', whereArgs: [metrics.date.toIso8601String()]);
  }

  Future<int> update(Metrics metrics) async {
    var db = await this.database;
    return await db.update(tableHistorial, metrics.toMap(),
        where: '$columnDateString = ?', whereArgs: [metrics.dateString]);
  }

  Future insertOrUpdate(Metrics metrics) async {
    var id = await update(metrics);
    if (id == 0) insertData(metrics);
  }

  Future<List<Metrics>> selectAllQuotes() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $tableHistorial ORDER BY $columnDate DESC');
    var quotes = result.map((qAsMap) => Metrics.fromMap(qAsMap));
    return quotes.toList();
  }

  Future<List<Metrics>> selectAllQuotesGraph() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $tableHistorial ORDER BY $columnDate ASC');
    var quotes = result.map((qAsMap) => Metrics.fromMap(qAsMap));
    return quotes.toList();
  }
}
