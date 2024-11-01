import 'package:hive/hive.dart';

part 'betreuer_model.g.dart';

@HiveType(typeId: 1)
class Betreuer extends HiveObject {
  @HiveField(0)
  String vorname;

  @HiveField(1)
  String nachname;

  @HiveField(2)
  String kommentar;

  Betreuer({
    required this.vorname,
    required this.nachname,
    required this.kommentar,
  });
}
