import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/veranstaltung_model.dart';
import '../models/bewohner_model.dart';
import '../models/betreuer_model.dart';
import 'package:hive/hive.dart';
class VeranstaltungPage extends StatefulWidget {
  const VeranstaltungPage({super.key});

  @override
  _VeranstaltungPageState createState() => _VeranstaltungPageState();
}

class _VeranstaltungPageState extends State<VeranstaltungPage> {
  final _veranstaltungBox = Hive.box<Veranstaltung>('veranstaltung');
  final _bewohnerBox = Hive.box<Bewohner>('bewohner');
  final _betreuerBox = Hive.box<Betreuer>('betreuer');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ortController = TextEditingController();
  final TextEditingController beschreibungController = TextEditingController();

  Map<Bewohner, bool> bewohnerCheckboxValues = {};
  Betreuer? ausgewaehlterBetreuer;
  DateTime? ausgewaehltesDatum = DateTime.now();
  TimeOfDay? anfangsZeit = TimeOfDay.now();
  TimeOfDay? endZeit = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _initBewohnerCheckboxes();
  }

  void _initBewohnerCheckboxes() {
    final bewohner = _bewohnerBox.values.toList();
    for (var b in bewohner) {
      bewohnerCheckboxValues[b] = false;
    }
  }

  void _addVeranstaltung() {
    final ausgewaehlteBewohner = bewohnerCheckboxValues.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (ausgewaehlteBewohner.isEmpty ||
        ausgewaehlterBetreuer == null ||
        ausgewaehltesDatum == null ||
        anfangsZeit == null ||
        endZeit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte alle Pflichtfelder ausfüllen')),
      );
      return;
    }

    final veranstaltung = Veranstaltung(
      name: nameController.text,
      teilnehmendeBewohner: ausgewaehlteBewohner,
      betreuer: ausgewaehlterBetreuer!,
      datum: ausgewaehltesDatum!,
      anfang: DateTime(
        ausgewaehltesDatum!.year,
        ausgewaehltesDatum!.month,
        ausgewaehltesDatum!.day,
        anfangsZeit!.hour,
        anfangsZeit!.minute,
      ),
      ende: DateTime(
        ausgewaehltesDatum!.year,
        ausgewaehltesDatum!.month,
        ausgewaehltesDatum!.day,
        endZeit!.hour,
        endZeit!.minute,
      ),
      ort: ortController.text,
      beschreibung: beschreibungController.text,
    );

    _veranstaltungBox.add(veranstaltung);
    _resetForm();
  }

  void _resetForm() {
    nameController.clear();
    ortController.clear();
    beschreibungController.clear();
    setState(() {
      ausgewaehlterBetreuer = null;
      for (var key in bewohnerCheckboxValues.keys) {
        bewohnerCheckboxValues[key] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veranstaltungen')),
      body: ValueListenableBuilder(
        valueListenable: _veranstaltungBox.listenable(),
        builder: (context, Box<Veranstaltung> box, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Eingabeformular
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name *'),
                ),
                TextField(
                  controller: ortController,
                  decoration: const InputDecoration(labelText: 'Ort *'),
                ),
                TextField(
                  controller: beschreibungController,
                  decoration: const InputDecoration(labelText: 'Beschreibung'),
                ),

                // Bewohner Checkboxen
                const SizedBox(height: 20),
                const Text('Teilnehmende Bewohner *:'),
                ...bewohnerCheckboxValues.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text('${entry.key.vorname} ${entry.key.nachname}'),
                    value: entry.value,
                    onChanged: (value) {
                      setState(() {
                        bewohnerCheckboxValues[entry.key] = value!;
                      });
                    },
                  );
                }),

                // Betreuer Dropdown
                DropdownButtonFormField<Betreuer>(
                  value: ausgewaehlterBetreuer,
                  decoration: const InputDecoration(labelText: 'Betreuer *'),
                  items: _betreuerBox.values.map((betreuer) {
                    return DropdownMenuItem(
                      value: betreuer,
                      child: Text('${betreuer.vorname} ${betreuer.nachname}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      ausgewaehlterBetreuer = value;
                    });
                  },
                ),

                // Datum und Zeit
                ListTile(
                  title: Text(ausgewaehltesDatum == null
                      ? 'Datum wählen *'
                      : 'Datum: ${ausgewaehltesDatum!.toLocal()}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: ausgewaehltesDatum ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() => ausgewaehltesDatum = date);
                    }
                  },
                ),

                // Buttons
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addVeranstaltung,
                  child: const Text('Veranstaltung hinzufügen'),
                ),

                // Liste der Veranstaltungen
                const SizedBox(height: 20),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final veranstaltung = box.getAt(index);
                    return ListTile(
                      title: Text(veranstaltung!.name),
                      subtitle: Text('Ort: ${veranstaltung.ort}\n'
                          'Betreuer: ${veranstaltung.betreuer.vorname} '
                          '${veranstaltung.betreuer.nachname}'),
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
