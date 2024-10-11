class Bewohner {
  int? id;
  String vorname;
  String nachname;
  int alter;
  String kommentar;

  Bewohner({
    this.id,
    required this.vorname,
    required this.nachname,
    required this.alter,
    required this.kommentar,
  });

  // Methode zum Erstellen eines Bewohner-Objekts aus einem JSON-Objekt
  factory Bewohner.fromJson(Map<String, dynamic> json) {
    return Bewohner(
      id: json['id'],
      vorname: json['vorname'],
      nachname: json['nachname'],
      alter: json['alter_age'],
      kommentar: '', // Provide a default value for kommentar
    );
  }

  // Methode zum Umwandeln eines Bewohner-Objekts in ein JSON-Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vorname': vorname,
      'nachname': nachname,
      'alter_age': alter,
      'kommentar': kommentar,
    };
  }

  // Methode zum Umwandeln eines Bewohner-Objekts in eine Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vorname': vorname,
      'nachname': nachname,
      'alter_age': alter,
    };
  }
}
