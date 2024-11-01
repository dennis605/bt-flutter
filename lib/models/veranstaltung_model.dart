import 'package:hive/hive.dart';
import 'bewohner_model.dart';
import 'betreuer_model.dart';

part 'veranstaltung_model.g.dart';

@HiveType(typeId: 2)
class Veranstaltung extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Bewohner> teilnehmendeBewohner;

  @HiveField(2)
  Betreuer betreuer;

  @HiveField(3)
  DateTime datum;

  @HiveField(4)
  DateTime anfang;

  @HiveField(5)
  DateTime ende;

  @HiveField(6)
  String ort;

  @HiveField(7)
  String beschreibung;

  Veranstaltung({
    required this.name,
    required this.teilnehmendeBewohner,
    required this.betreuer,
    required this.datum,
    required this.anfang,
    required this.ende,
    required this.ort,
    required this.beschreibung,
  });
}