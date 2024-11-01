import 'package:hive/hive.dart';
import 'veranstaltung_model.dart';

part 'tagesplan_model.g.dart';

@HiveType(typeId: 3)
class Tagesplan extends HiveObject {
  @HiveField(0)
  DateTime datum;

  @HiveField(1)
  List<Veranstaltung> veranstaltungen;

  Tagesplan({
    required this.datum,
    required this.veranstaltungen,
  });
}
