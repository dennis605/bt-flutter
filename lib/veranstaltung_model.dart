import 'bewohner_model.dart';
import 'betreuer_model.dart';

class Veranstaltung {
  int? id; // Hinzugefügtes id-Feld
  String name;
  List<Bewohner> teilnehmendeBewohner;
  Betreuer betreuer;
  DateTime datum;
  DateTime anfang;
  DateTime ende;
  String ort;
  String beschreibung;

  Veranstaltung({
    this.id, // Optionales id-Feld
    required this.name,
    required this.teilnehmendeBewohner,
    required this.betreuer,
    required this.datum,
    required this.anfang,
    required this.ende,
    required this.ort,
    required this.beschreibung,
  });

  // Methode zum Erstellen einer Veranstaltung aus einem JSON-Objekt
  factory Veranstaltung.fromJson(Map<String, dynamic> json) {
    return Veranstaltung(
      id: json['id'], // id aus dem JSON-Objekt
      name: json['name'],
      teilnehmendeBewohner: List<Bewohner>.from(json['teilnehmendeBewohner'].map((bew) => Bewohner.fromJson(bew))),
      betreuer: Betreuer.fromJson(json['betreuer']),
      datum: DateTime.parse(json['datum']),
      anfang: DateTime.parse(json['anfang']),
      ende: DateTime.parse(json['ende']),
      ort: json['ort'],
      beschreibung: json['beschreibung'],
    );
  }

  // Methode zum Umwandeln einer Veranstaltung in ein JSON-Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id, // id hinzufügen
      'name': name,
      'teilnehmendeBewohner': teilnehmendeBewohner.map((bew) => bew.toJson()).toList(),
      'betreuer': betreuer.toJson(),
      'datum': datum.toIso8601String(),
      'anfang': anfang.toIso8601String(),
      'ende': ende.toIso8601String(),
      'ort': ort,
      'beschreibung': beschreibung,
    };
  }
}
