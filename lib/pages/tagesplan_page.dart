import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/tagesplan_model.dart';
import '../models/veranstaltung_model.dart';
import 'package:hive/hive.dart';


class TagesplanPage extends StatefulWidget {
  const TagesplanPage({super.key});

  @override
  _TagesplanPageState createState() => _TagesplanPageState();
}

class _TagesplanPageState extends State<TagesplanPage> {
  final _tagesplanBox = Hive.box<Tagesplan>('tagesplan');
  final _veranstaltungBox = Hive.box<Veranstaltung>('veranstaltung');

  DateTime? ausgewaehltesDatum;
  List<Veranstaltung> ausgewaehlteVeranstaltungen = [];

  void _addTagesplan() {
    if (ausgewaehltesDatum == null || ausgewaehlteVeranstaltungen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Bitte Datum und mindestens eine Veranstaltung auswählen'),
        ),
      );
      return;
    }

    final tagesplan = Tagesplan(
      datum: ausgewaehltesDatum!,
      veranstaltungen: List.from(ausgewaehlteVeranstaltungen),
    );

    _tagesplanBox.add(tagesplan);
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      ausgewaehltesDatum = null;
      ausgewaehlteVeranstaltungen.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tagespläne')),
      body: ValueListenableBuilder(
        valueListenable: _tagesplanBox.listenable(),
        builder: (context, Box<Tagesplan> box, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Datum auswählen
                ListTile(
                  title: Text(ausgewaehltesDatum == null
                      ? 'Datum wählen *'
                      : 'Datum: ${ausgewaehltesDatum!.toLocal()}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => ausgewaehltesDatum = date);
                    }
                  },
                ),

                // Veranstaltungen auswählen
                const SizedBox(height: 20),
                const Text('Veranstaltungen auswählen *:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _veranstaltungBox.length,
                  itemBuilder: (context, index) {
                    final veranstaltung = _veranstaltungBox.getAt(index)!;
                    return CheckboxListTile(
                      title: Text(veranstaltung.name),
                      subtitle: Text('Ort: ${veranstaltung.ort}\n'
                          'Zeit: ${veranstaltung.anfang.hour}:${veranstaltung.anfang.minute} - '
                          '${veranstaltung.ende.hour}:${veranstaltung.ende.minute}'),
                      value:
                          ausgewaehlteVeranstaltungen.contains(veranstaltung),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            ausgewaehlteVeranstaltungen.add(veranstaltung);
                          } else {
                            ausgewaehlteVeranstaltungen.remove(veranstaltung);
                          }
                        });
                      },
                    );
                  },
                ),

                // Tagesplan erstellen Button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addTagesplan,
                  child: const Text('Tagesplan erstellen'),
                ),

                // Liste der Tagespläne
                const SizedBox(height: 20),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final tagesplan = box.getAt(index)!;
                    return ExpansionTile(
                      title: Text('Tagesplan: ${tagesplan.datum.toLocal()}'),
                      children: [
                        ...tagesplan.veranstaltungen.map((v) => ListTile(
                              title: Text(v.name),
                              subtitle:
                                  Text('${v.anfang.hour}:${v.anfang.minute} - '
                                      '${v.ende.hour}:${v.ende.minute}\n'
                                      'Ort: ${v.ort}'),
                            )),
                      ],
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => box.deleteAt(index),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
