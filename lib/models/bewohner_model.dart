import 'package:hive/hive.dart';

part 'bewohner_model.g.dart';

@HiveType(typeId: 0)
class Bewohner extends HiveObject {
  @HiveField(0)
  String vorname;

  @HiveField(1)
  String nachname;

  @HiveField(2)
  int alter;

  @HiveField(3)
  String kommentar;

  Bewohner({
    required this.vorname,
    required this.nachname,
    required this.alter,
    required this.kommentar,
  });
}