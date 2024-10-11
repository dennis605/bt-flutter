import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'bewohner_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bewohner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bewohner(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vorname TEXT,
        nachname TEXT,
        alter_age INTEGER
      )
    ''');
  }

  Future<int> insertBewohner(Bewohner bewohner) async {
    Database db = await database;
    return await db.insert('bewohner', bewohner.toMap());
  }

  Future<List<Bewohner>> getBewohner() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bewohner');
    return List.generate(maps.length, (i) {
      return Bewohner(
        id: maps[i]['id'],
        vorname: maps[i]['vorname'],
        nachname: maps[i]['nachname'],
        alter: maps[i]['alter_age'],
        kommentar: '', // Provide a default value for kommentar
      );
    });
  }

  Future<int> updateBewohner(Bewohner bewohner) async {
    Database db = await database;
    return await db.update(
      'bewohner',
      bewohner.toMap(),
      where: 'id = ?',
      whereArgs: [bewohner.id],
    );
  }

  Future<int> deleteBewohner(int id) async {
    Database db = await database;
    return await db.delete(
      'bewohner',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
