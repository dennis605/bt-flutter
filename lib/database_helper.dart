import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast/sembast_memory.dart' as sembast_memory;
import 'bewohner_model.dart';
import 'betreuer_model.dart';
import 'veranstaltung_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _sqfliteDatabase;
  static sembast.Database? _sembastDatabase;

  DatabaseHelper._internal();

  Future<dynamic> get database async {
    if (kIsWeb) {
      if (_sembastDatabase != null) return _sembastDatabase!;
      _sembastDatabase = await _initSembastDatabase();
      return _sembastDatabase!;
    } else {
      if (_sqfliteDatabase != null) return _sqfliteDatabase!;
      _sqfliteDatabase = await _initSqfliteDatabase();
      return _sqfliteDatabase!;
    }
  }

  Future<Database> _initSqfliteDatabase() async {
    String path = join(await getDatabasesPath(), 'bewohner.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<sembast.Database> _initSembastDatabase() async {
    final String dbPath = 'bewohner.db';
    final sembast.DatabaseFactory dbFactory = sembast_memory.databaseFactoryMemory;
    final sembast.Database db = await dbFactory.openDatabase(dbPath);
    return db;
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
    
    await db.execute('''
      CREATE TABLE betreuer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vorname TEXT,
        nachname TEXT,
        kommentar TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE veranstaltung(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        datum TEXT,
        anfang TEXT,
        ende TEXT,
        ort TEXT,
        beschreibung TEXT,
        betreuer_id INTEGER,
        FOREIGN KEY (betreuer_id) REFERENCES betreuer (id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('DROP TABLE IF EXISTS bewohner');
    await db.execute('DROP TABLE IF EXISTS betreuer');
    await db.execute('DROP TABLE IF EXISTS veranstaltung');
    await _onCreate(db, newVersion);
  }

  Future<int> insertBewohner(Bewohner bewohner) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('bewohner');
      return await store.add(db, bewohner.toMap());
    } else {
      return await db.insert('bewohner', bewohner.toMap());
    }
  }

  Future<List<Bewohner>> getBewohner() async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('bewohner');
      final records = await store.find(db);
      return records.map((record) {
        return Bewohner(
          id: record.key as int,
          vorname: record['vorname'] as String,
          nachname: record['nachname'] as String,
          alter: record['alter_age'] as int,
          kommentar: '',
        );
      }).toList();
    } else {
      final List<Map<String, dynamic>> maps = await db.query('bewohner');
      return List.generate(maps.length, (i) {
        return Bewohner(
          id: maps[i]['id'],
          vorname: maps[i]['vorname'],
          nachname: maps[i]['nachname'],
          alter: maps[i]['alter_age'],
          kommentar: '',
        );
      });
    }
  }

  Future<int> updateBewohner(Bewohner bewohner) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('bewohner');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(bewohner.id));
      return await store.update(db, bewohner.toMap(), finder: finder);
    } else {
      return await db.update(
        'bewohner',
        bewohner.toMap(),
        where: 'id = ?',
        whereArgs: [bewohner.id],
      );
    }
  }

  Future<int> deleteBewohner(int id) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('bewohner');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(id));
      return await store.delete(db, finder: finder);
    } else {
      return await db.delete(
        'bewohner',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Methoden für Betreuer

  Future<int> insertBetreuer(Betreuer betreuer) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('betreuer');
      return await store.add(db, betreuer.toMap());
    } else {
      return await db.insert('betreuer', betreuer.toMap());
    }
  }

  Future<List<Betreuer>> getBetreuer() async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('betreuer');
      final records = await store.find(db);
      return records.map((record) {
        return Betreuer(
          id: record.key as int,
          vorname: record['vorname'] as String,
          nachname: record['nachname'] as String,
          kommentar: record['kommentar'] as String? ?? '',
        );
      }).toList();
    } else {
      final List<Map<String, dynamic>> maps = await db.query('betreuer');
      return List.generate(maps.length, (i) {
        return Betreuer(
          id: maps[i]['id'],
          vorname: maps[i]['vorname'],
          nachname: maps[i]['nachname'],
          kommentar: maps[i]['kommentar'] ?? '',
        );
      });
    }
  }

  Future<int> updateBetreuer(Betreuer betreuer) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('betreuer');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(betreuer.id));
      return await store.update(db, betreuer.toMap(), finder: finder);
    } else {
      return await db.update(
        'betreuer',
        betreuer.toMap(),
        where: 'id = ?',
        whereArgs: [betreuer.id],
      );
    }
  }

  Future<int> deleteBetreuer(int id) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('betreuer');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(id));
      return await store.delete(db, finder: finder);
    } else {
      return await db.delete(
        'betreuer',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Methoden für Veranstaltungen

  Future<int> insertVeranstaltung(Veranstaltung veranstaltung) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('veranstaltung');
      return await store.add(db, {
        'name': veranstaltung.name,
        'datum': veranstaltung.datum.toIso8601String(),
        'anfang': veranstaltung.anfang.toIso8601String(),
        'ende': veranstaltung.ende.toIso8601String(),
        'ort': veranstaltung.ort,
        'beschreibung': veranstaltung.beschreibung,
        'betreuer_id': veranstaltung.betreuer.id,
      });
    } else {
      return await db.insert('veranstaltung', {
        'name': veranstaltung.name,
        'datum': veranstaltung.datum.toIso8601String(),
        'anfang': veranstaltung.anfang.toIso8601String(),
        'ende': veranstaltung.ende.toIso8601String(),
        'ort': veranstaltung.ort,
        'beschreibung': veranstaltung.beschreibung,
        'betreuer_id': veranstaltung.betreuer.id,
      });
    }
  }

  Future<List<Veranstaltung>> getVeranstaltungen() async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('veranstaltung');
      final records = await store.find(db);
      return records.map((record) {
        return Veranstaltung(
          id: record.key as int,
          name: record['name'] as String,
          teilnehmendeBewohner: [],
          betreuer: Betreuer(id: record['betreuer_id'] as int, vorname: '', nachname: '', kommentar: ''),
          datum: DateTime.parse(record['datum'] as String),
          anfang: DateTime.parse(record['anfang'] as String),
          ende: DateTime.parse(record['ende'] as String),
          ort: record['ort'] as String,
          beschreibung: record['beschreibung'] as String,
        );
      }).toList();
    } else {
      final List<Map<String, dynamic>> maps = await db.query('veranstaltung');
      return List.generate(maps.length, (i) {
        return Veranstaltung(
          id: maps[i]['id'],
          name: maps[i]['name'],
          teilnehmendeBewohner: [],
          betreuer: Betreuer(id: maps[i]['betreuer_id'], vorname: '', nachname: '', kommentar: ''),
          datum: DateTime.parse(maps[i]['datum']),
          anfang: DateTime.parse(maps[i]['anfang']),
          ende: DateTime.parse(maps[i]['ende']),
          ort: maps[i]['ort'],
          beschreibung: maps[i]['beschreibung'],
        );
      });
    }
  }

  Future<int> updateVeranstaltung(Veranstaltung veranstaltung) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('veranstaltung');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(veranstaltung.id));
      return await store.update(db, {
        'name': veranstaltung.name,
        'datum': veranstaltung.datum.toIso8601String(),
        'anfang': veranstaltung.anfang.toIso8601String(),
        'ende': veranstaltung.ende.toIso8601String(),
        'ort': veranstaltung.ort,
        'beschreibung': veranstaltung.beschreibung,
        'betreuer_id': veranstaltung.betreuer.id,
      }, finder: finder);
    } else {
      return await db.update(
        'veranstaltung',
        {
          'name': veranstaltung.name,
          'datum': veranstaltung.datum.toIso8601String(),
          'anfang': veranstaltung.anfang.toIso8601String(),
          'ende': veranstaltung.ende.toIso8601String(),
          'ort': veranstaltung.ort,
          'beschreibung': veranstaltung.beschreibung,
          'betreuer_id': veranstaltung.betreuer.id,
        },
        where: 'id = ?',
        whereArgs: [veranstaltung.id],
      );
    }
  }

  Future<int> deleteVeranstaltung(int id) async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('veranstaltung');
      final finder = sembast.Finder(filter: sembast.Filter.byKey(id));
      return await store.delete(db, finder: finder);
    } else {
      return await db.delete(
        'veranstaltung',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Methode zur Überprüfung der Tabellen
  Future<List<String>> getTableNames() async {
    final db = await database;
    if (kIsWeb) {
      final store = sembast.intMapStoreFactory.store('sqlite_master');
      final records = await store.find(db);
      return records.map((record) => record['name'] as String).toList();
    } else {
      final List<Map<String, dynamic>> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      return tables.map((table) => table['name'] as String).toList();
    }
  }
}
