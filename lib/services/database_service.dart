import 'package:hive_flutter/hive_flutter.dart';
import '../models/bewohner_model.dart';
import '../models/betreuer_model.dart';
import '../models/veranstaltung_model.dart';
import '../models/tagesplan_model.dart';
import 'package:hive/hive.dart';

class DatabaseService {
  static const String bewohnerBox = 'bewohner';
  static const String betreuerBox = 'betreuer';
  static const String veranstaltungBox = 'veranstaltung';
  static const String tagesplanBox = 'tagesplan';

  static Future<void> initHive() async {
    try {
      // Registriere Adapter
      if (!Hive.isAdapterRegistered(0)) {
        print("Registriere BewohnerAdapter");
        Hive.registerAdapter(BewohnerAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        print("Registriere BetreuerAdapter");
        Hive.registerAdapter(BetreuerAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        print("Registriere VeranstaltungAdapter");
        Hive.registerAdapter(VeranstaltungAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        print("Registriere TagesplanAdapter");
        Hive.registerAdapter(TagesplanAdapter());
      }

      // Öffne Boxen
      if (!Hive.isBoxOpen(bewohnerBox)) {
        print("Öffne BewohnerBox");
        await Hive.openBox<Bewohner>(bewohnerBox);
      }
      if (!Hive.isBoxOpen(betreuerBox)) {
        print("Öffne BetreuerBox");
        await Hive.openBox<Betreuer>(betreuerBox);
      }
      if (!Hive.isBoxOpen(veranstaltungBox)) {
        print("Öffne VeranstaltungBox");
        await Hive.openBox<Veranstaltung>(veranstaltungBox);
      }
      if (!Hive.isBoxOpen(tagesplanBox)) {
        print("Öffne TagesplanBox");
        await Hive.openBox<Tagesplan>(tagesplanBox);
      }

      print("DatabaseService: Initialisierung abgeschlossen");
      final box = Hive.box<Bewohner>(bewohnerBox);
      print("Anzahl der Bewohner in der Box: ${box.length}");
      print("Alle Bewohner: ${box.values.toList()}");
      
      // Überprüfe den Box-Status
      print("Box Status:");
      print("- Name: ${box.name}");
      print("- Ist offen: ${box.isOpen}");
      print("- Länge: ${box.length}");
      print("- Keys: ${box.keys.toList()}");
      print("- Werte: ${box.values.toList()}");
      
      // Erzwinge das Speichern
      await box.flush();
      
    } catch (e, stackTrace) {
      print("Fehler bei der Initialisierung: $e");
      print("Stacktrace: $stackTrace");
      rethrow;
    }
  }

  // Bewohner CRUD
  Future<void> addBewohner(Bewohner bewohner) async {
    try {
      final box = Hive.box<Bewohner>(bewohnerBox);
      
      // Generiere einen eindeutigen Key
      final key = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Speichere den Bewohner
      await box.put(key, bewohner);
      print("Bewohner hinzugefügt mit Key: $key");
      print("Bewohner: $bewohner");
      print("Neue Anzahl der Bewohner: ${box.length}");
      print("Alle Bewohner nach Hinzufügen: ${box.values.toList()}");
      
      // Überprüfe den Box-Status nach dem Hinzufügen
      print("Box Status nach Hinzufügen:");
      print("- Länge: ${box.length}");
      print("- Keys: ${box.keys.toList()}");
      print("- Werte: ${box.values.toList()}");
      
      // Erzwinge das Speichern
      await box.flush();
      
    } catch (e, stackTrace) {
      print("Fehler beim Hinzufügen des Bewohners: $e");
      print("Stacktrace: $stackTrace");
      rethrow;
    }
  }

  List<Bewohner> getAllBewohner() {
    try {
      final box = Hive.box<Bewohner>(bewohnerBox);
      final bewohner = box.values.toList();
      print("Geladene Bewohner: $bewohner");
      return bewohner;
    } catch (e, stackTrace) {
      print("Fehler beim Laden der Bewohner: $e");
      print("Stacktrace: $stackTrace");
      return [];
    }
  }

  Future<void> updateBewohner(int index, Bewohner bewohner) async {
    try {
      final box = Hive.box<Bewohner>(bewohnerBox);
      final key = box.keyAt(index);
      await box.put(key, bewohner);
      print("Bewohner aktualisiert: $bewohner");
      print("Alle Bewohner nach Update: ${box.values.toList()}");
      
      // Erzwinge das Speichern
      await box.flush();
      
    } catch (e, stackTrace) {
      print("Fehler beim Aktualisieren des Bewohners: $e");
      print("Stacktrace: $stackTrace");
      rethrow;
    }
  }

  Future<void> deleteBewohner(int index) async {
    try {
      final box = Hive.box<Bewohner>(bewohnerBox);
      final key = box.keyAt(index);
      await box.delete(key);
      print("Bewohner gelöscht an Index: $index");
      print("Alle Bewohner nach Löschen: ${box.values.toList()}");
      
      // Erzwinge das Speichern
      await box.flush();
      
    } catch (e, stackTrace) {
      print("Fehler beim Löschen des Bewohners: $e");
      print("Stacktrace: $stackTrace");
      rethrow;
    }
  }
}
