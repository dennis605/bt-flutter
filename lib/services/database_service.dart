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
    await Hive.initFlutter();
    
    Hive.registerAdapter(BewohnerAdapter());
    Hive.registerAdapter(BetreuerAdapter());
    Hive.registerAdapter(VeranstaltungAdapter());
    Hive.registerAdapter(TagesplanAdapter());
    
    await Hive.openBox<Bewohner>(bewohnerBox);
    await Hive.openBox<Betreuer>(betreuerBox);
    await Hive.openBox<Veranstaltung>(veranstaltungBox);
    await Hive.openBox<Tagesplan>(tagesplanBox);
  }

  // Bewohner CRUD
  Future<void> addBewohner(Bewohner bewohner) async {
    final box = Hive.box<Bewohner>(bewohnerBox);
    await box.add(bewohner);
  }

  List<Bewohner> getAllBewohner() {
    final box = Hive.box<Bewohner>(bewohnerBox);
    return box.values.toList();
  }

  Future<void> updateBewohner(int index, Bewohner bewohner) async {
    final box = Hive.box<Bewohner>(bewohnerBox);
    await box.putAt(index, bewohner);
  }

  Future<void> deleteBewohner(int index) async {
    final box = Hive.box<Bewohner>(bewohnerBox);
    await box.deleteAt(index);
  }

  // Betreuer CRUD
  Future<void> addBetreuer(Betreuer betreuer) async {
    final box = Hive.box<Betreuer>(betreuerBox);
    await box.add(betreuer);
  }

  List<Betreuer> getAllBetreuer() {
    final box = Hive.box<Betreuer>(betreuerBox);
    return box.values.toList();
  }

  Future<void> updateBetreuer(int index, Betreuer betreuer) async {
    final box = Hive.box<Betreuer>(betreuerBox);
    await box.putAt(index, betreuer);
  }

  Future<void> deleteBetreuer(int index) async {
    final box = Hive.box<Betreuer>(betreuerBox);
    await box.deleteAt(index);
  }

  // Veranstaltung CRUD
  Future<void> addVeranstaltung(Veranstaltung veranstaltung) async {
    final box = Hive.box<Veranstaltung>(veranstaltungBox);
    await box.add(veranstaltung);
  }

  List<Veranstaltung> getAllVeranstaltungen() {
    final box = Hive.box<Veranstaltung>(veranstaltungBox);
    return box.values.toList();
  }

  Future<void> updateVeranstaltung(int index, Veranstaltung veranstaltung) async {
    final box = Hive.box<Veranstaltung>(veranstaltungBox);
    await box.putAt(index, veranstaltung);
  }

  Future<void> deleteVeranstaltung(int index) async {
    final box = Hive.box<Veranstaltung>(veranstaltungBox);
    await box.deleteAt(index);
  }

  // Tagesplan CRUD
  Future<void> addTagesplan(Tagesplan tagesplan) async {
    final box = Hive.box<Tagesplan>(tagesplanBox);
    await box.add(tagesplan);
  }

  List<Tagesplan> getAllTagesplaene() {
    final box = Hive.box<Tagesplan>(tagesplanBox);
    return box.values.toList();
  }

  Future<void> updateTagesplan(int index, Tagesplan tagesplan) async {
    final box = Hive.box<Tagesplan>(tagesplanBox);
    await box.putAt(index, tagesplan);
  }

  Future<void> deleteTagesplan(int index) async {
    final box = Hive.box<Tagesplan>(tagesplanBox);
    await box.deleteAt(index);
  }
}