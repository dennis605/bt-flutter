import 'package:flutter/material.dart';
import 'veranstaltung_model.dart';
import 'bewohner_model.dart';
import 'betreuer_model.dart';
import 'database_helper.dart'; // Importiere den DatabaseHelper

class VeranstaltungPage extends StatefulWidget {
  const VeranstaltungPage({super.key});
  @override
  _VeranstaltungPageState createState() => _VeranstaltungPageState();
}

class _VeranstaltungPageState extends State<VeranstaltungPage> {
  // Liste der Veranstaltungen
  List<Veranstaltung> veranstaltungenListe = [];
  final DatabaseHelper databaseHelper = DatabaseHelper(); // Instanz des DatabaseHelper

  // Dummy-Daten für Bewohner und Betreuer
  List<Bewohner> bewohnerDummyListe = [
    Bewohner(vorname: "Max", nachname: "Mustermann", alter: 30, kommentar: "Kommentar 1"),
    Bewohner(vorname: "Erika", nachname: "Mustermann", alter: 25, kommentar: "Kommentar 2"),
    Bewohner(vorname: "Hans", nachname: "Meyer", alter: 35, kommentar: "Kommentar 3"),
  ];

  List<Betreuer> betreuerDummyListe = [
    Betreuer(vorname: "Herr", nachname: "Betreuer", kommentar: "Kommentar A"),
    Betreuer(vorname: "Frau", nachname: "Betreuerin", kommentar: "Kommentar B"),
  ];

  // Auswahl von Bewohnern und Betreuern
  Map<Bewohner, bool> bewohnerCheckboxValues = {}; // Für Checkboxen
  Betreuer? ausgewaehlterBetreuer;

  // Controller für das Formular
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ortController = TextEditingController();
  final TextEditingController beschreibungController = TextEditingController();

  // Datum und Zeit auswählen
  DateTime? ausgewaehltesDatum = DateTime.now(); // Standardwert auf heute setzen
  TimeOfDay? anfangsZeit = TimeOfDay.now(); // Standardwert auf jetzt setzen
  TimeOfDay? endZeit = TimeOfDay.now(); // Standardwert auf jetzt setzen

  @override
  void initState() {
    super.initState();
    _loadVeranstaltungen(); // Veranstaltungen beim Start laden
    for (var bewohner in bewohnerDummyListe) {
      bewohnerCheckboxValues[bewohner] = false;
    }
    _checkDatabaseTables(); // Überprüfe die Tabellen in der Datenbank
  }

  // Veranstaltungen laden
  void _loadVeranstaltungen() async {
    veranstaltungenListe = await databaseHelper.getVeranstaltungen();
    setState(() {});
  }

  // Überprüfe die Tabellen in der Datenbank
  void _checkDatabaseTables() async {
    List<String> tables = await databaseHelper.getTableNames();
    if (!tables.contains('veranstaltung')) {
      print('Die Tabelle "veranstaltung" existiert nicht.');
    } else {
      print('Die Tabelle "veranstaltung" existiert.');
    }
  }

  // Funktion zum Hinzufügen einer Veranstaltung
  void _addVeranstaltung() async {
    List<Bewohner> ausgewaehlteBewohner = bewohnerCheckboxValues.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (ausgewaehlteBewohner.isEmpty || ausgewaehlterBetreuer == null || ausgewaehltesDatum == null || anfangsZeit == null || endZeit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte alle Pflichtfelder ausfüllen.'),
        ),
      );
      return;
    }

    Veranstaltung neueVeranstaltung = Veranstaltung(
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

    // Füge die Veranstaltung zur Datenbank hinzu
    await databaseHelper.insertVeranstaltung(neueVeranstaltung);
    
    setState(() {
      veranstaltungenListe.add(neueVeranstaltung);
    });

    _resetForm();
  }

  // Formular zurücksetzen
  void _resetForm() {
    nameController.clear();
    ortController.clear();
    beschreibungController.clear();
    ausgewaehlterBetreuer = null;
    ausgewaehltesDatum = DateTime.now(); // Setze auf heute zurück
    anfangsZeit = TimeOfDay.now(); // Setze auf jetzt zurück
    endZeit = TimeOfDay.now(); // Setze auf jetzt zurück

    for (var bewohner in bewohnerCheckboxValues.keys) {
      bewohnerCheckboxValues[bewohner] = false;
    }
  }

  // Veranstaltung bearbeiten
  void _editVeranstaltung(int index) {
    Veranstaltung veranstaltung = veranstaltungenListe[index];

    // Lade die vorhandenen Daten in das Formular
    nameController.text = veranstaltung.name;
    ortController.text = veranstaltung.ort;
    beschreibungController.text = veranstaltung.beschreibung;
    ausgewaehlterBetreuer = veranstaltung.betreuer;
    ausgewaehltesDatum = veranstaltung.datum;
    anfangsZeit = TimeOfDay.fromDateTime(veranstaltung.anfang);
    endZeit = TimeOfDay.fromDateTime(veranstaltung.ende);

    // Markiere die Teilnehmer im Checkbox-Formular
    for (var bewohner in bewohnerCheckboxValues.keys) {
      bewohnerCheckboxValues[bewohner] = veranstaltung.teilnehmendeBewohner.contains(bewohner);
    }

    // Öffne den Dialog zum Bearbeiten
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Veranstaltung bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Veranstaltungsname *',
                    hintText: 'Geben Sie den Namen der Veranstaltung ein',
                  ),
                ),
                TextField(
                  controller: ortController,
                  decoration: const InputDecoration(
                    labelText: 'Ort *',
                    hintText: 'Geben Sie den Veranstaltungsort ein',
                  ),
                ),
                TextField(
                  controller: beschreibungController,
                  decoration: const InputDecoration(
                    labelText: 'Beschreibung',
                    hintText: 'Geben Sie eine optionale Beschreibung ein',
                  ),
                ),
                const SizedBox(height: 20),

                // Bewohnerauswahl in Checkboxen anzeigen
                const Text('Bewohner auswählen *:'),
                Column(
                  children: bewohnerCheckboxValues.entries.map((entry) {
                    return CheckboxListTile(
                      title: Text('${entry.key.vorname} ${entry.key.nachname}'),
                      value: entry.value,
                      onChanged: (bool? value) {
                        setState(() {
                          bewohnerCheckboxValues[entry.key] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),

                // Dropdown für Betreuer-Auswahl
                DropdownButtonFormField<Betreuer>(
                  decoration: const InputDecoration(
                    labelText: 'Betreuer auswählen *',
                    hintText: 'Wählen Sie einen Betreuer aus',
                  ),
                  items: betreuerDummyListe.map((betreuer) {
                    return DropdownMenuItem<Betreuer>(
                      value: betreuer,
                      child: Text('${betreuer.vorname} ${betreuer.nachname}'),
                    );
                  }).toList(),
                  onChanged: (betreuer) {
                    setState(() {
                      ausgewaehlterBetreuer = betreuer;
                    });
                  },
                  value: ausgewaehlterBetreuer,
                ),

                // Datumsauswahl
                ListTile(
                  title: Text(
                    ausgewaehltesDatum == null ? 'Datum auswählen *' : 'Datum: ${ausgewaehltesDatum!.toLocal()}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),

                // Zeit-Auswahl für Anfang und Ende
                ListTile(
                  title: Text(
                    anfangsZeit == null ? 'Anfangszeit auswählen *' : 'Anfang: ${anfangsZeit!.format(context)}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _pickTime(context, true),
                ),
                ListTile(
                  title: Text(
                    endZeit == null ? 'Endzeit auswählen *' : 'Ende: ${endZeit!.format(context)}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _pickTime(context, false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveEditedVeranstaltung(index);
                Navigator.of(context).pop();
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  // Speichert die bearbeitete Veranstaltung
  void _saveEditedVeranstaltung(int index) async {
    List<Bewohner> ausgewaehlteBewohner = bewohnerCheckboxValues.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (ausgewaehlteBewohner.isEmpty || ausgewaehlterBetreuer == null || ausgewaehltesDatum == null || anfangsZeit == null || endZeit == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bitte alle Felder ausfüllen und Teilnehmer auswählen.'),
      ));
      return;
    }

    Veranstaltung aktualisierteVeranstaltung = Veranstaltung(
      id: veranstaltungenListe[index].id, // Behalte die ID bei der Aktualisierung
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

    // Aktualisiere die Veranstaltung in der Datenbank
    await databaseHelper.updateVeranstaltung(aktualisierteVeranstaltung);
    
    setState(() {
      veranstaltungenListe[index] = aktualisierteVeranstaltung;
    });

    _resetForm();
  }

  // Datumsauswahl
  Future<void> _pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: ausgewaehltesDatum ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        ausgewaehltesDatum = selectedDate;
      });
    }
  }

  // Zeit auswählen im 24-Stunden-Format
  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? anfangsZeit ?? TimeOfDay.now() : endZeit ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          anfangsZeit = pickedTime;
        } else {
          endZeit = pickedTime;
        }
      });
    }
  }

  // Veranstaltung löschen
  void _deleteVeranstaltung(int index) async {
    await databaseHelper.deleteVeranstaltung(veranstaltungenListe[index].id!);
    setState(() {
      veranstaltungenListe.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veranstaltungen verwalten'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Eingabefelder für die Veranstaltung
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Veranstaltungsname *',
                  hintText: 'Geben Sie den Namen der Veranstaltung ein',
                ),
              ),
              TextField(
                controller: ortController,
                decoration: const InputDecoration(
                  labelText: 'Ort *',
                  hintText: 'Geben Sie den Veranstaltungsort ein',
                ),
              ),
              TextField(
                controller: beschreibungController,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  hintText: 'Geben Sie eine optionale Beschreibung ein',
                ),
              ),
              const SizedBox(height: 20),

              // Bewohner-Auswahl mit Checkboxen
              const Text('Bewohner auswählen *:'),
              Column(
                children: bewohnerCheckboxValues.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text('${entry.key.vorname} ${entry.key.nachname}'),
                    value: entry.value,
                    onChanged: (bool? value) {
                      setState(() {
                        bewohnerCheckboxValues[entry.key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),

              // Betreuer-Auswahl
              DropdownButtonFormField<Betreuer>(
                decoration: const InputDecoration(
                  labelText: 'Betreuer auswählen *',
                  hintText: 'Wählen Sie einen Betreuer aus',
                ),
                items: betreuerDummyListe.map((betreuer) {
                  return DropdownMenuItem<Betreuer>(
                    value: betreuer,
                    child: Text('${betreuer.vorname} ${betreuer.nachname}'),
                  );
                }).toList(),
                onChanged: (betreuer) {
                  setState(() {
                    ausgewaehlterBetreuer = betreuer;
                  });
                },
                value: ausgewaehlterBetreuer,
              ),
              const SizedBox(height: 20),

              // Datumsauswahl
              ListTile(
                title: Text(
                  ausgewaehltesDatum == null
                      ? 'Datum auswählen *'
                      : 'Datum: ${ausgewaehltesDatum!.toLocal()}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),

              // Zeit für Anfang und Ende auswählen (24-Stunden-Format)
              ListTile(
                title: Text(
                  anfangsZeit == null ? 'Anfangszeit auswählen *' : 'Anfang: ${anfangsZeit!.format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context, true),
              ),
              ListTile(
                title: Text(
                  endZeit == null ? 'Endzeit auswählen *' : 'Ende: ${endZeit!.format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(context, false),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _addVeranstaltung,
                child: const Text('Veranstaltung hinzufügen'),
              ),
              const Divider(),
              // Liste der Veranstaltungen anzeigen
              ListView.builder(
                shrinkWrap: true,
                itemCount: veranstaltungenListe.length,
                itemBuilder: (context, index) {
                  final veranstaltung = veranstaltungenListe[index];
                  return ListTile(
                    title: Text(veranstaltung.name),
                    subtitle: Text(
                      'Ort: ${veranstaltung.ort}\nBetreuer: ${veranstaltung.betreuer.vorname} ${veranstaltung.betreuer.nachname}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editVeranstaltung(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteVeranstaltung(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
