class Betreuer {
  int? id;
  String vorname;
  String nachname;
  String kommentar;

  Betreuer({
    this.id,
    required this.vorname,
    required this.nachname,
    required this.kommentar,
  });

  // Methode zum Erstellen eines Betreuer-Objekts aus einem JSON-Objekt
  factory Betreuer.fromJson(Map<String, dynamic> json) {
    return Betreuer(
      id: json['id'],
      vorname: json['vorname'],
      nachname: json['nachname'],
      kommentar: json['kommentar'] ?? '', // Standardwert für kommentar
    );
  }

  // Methode zum Umwandeln eines Betreuer-Objekts in ein JSON-Objekt
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vorname': vorname,
      'nachname': nachname,
      'kommentar': kommentar,
    };
  }

  // Methode zum Umwandeln eines Betreuer-Objekts in eine Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vorname': vorname,
      'nachname': nachname,
    };
  }
}
