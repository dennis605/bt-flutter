import 'package:flutter/material.dart';
import 'bewohner_model.dart'; // Importiere das Bewohnermodell
import 'database_helper.dart'; // Importiere den Datenbankhelper

class BewohnerPage extends StatefulWidget {
  @override
  _BewohnerPageState createState() => _BewohnerPageState();
}

class _BewohnerPageState extends State<BewohnerPage> {
  // Liste der Bewohner
  List<Bewohner> bewohnerListe = [];
  final DatabaseHelper databaseHelper = DatabaseHelper();

  // Controller für das Formular
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController alterController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBewohner();
  }

  // Bewohner laden
  void _loadBewohner() async {
    bewohnerListe = await databaseHelper.getBewohner();
    setState(() {});
  }

  // Bewohner hinzufügen
  void _addBewohner() async {
    final neuerBewohner = Bewohner(
      vorname: vornameController.text,
      nachname: nachnameController.text,
      alter: int.parse(alterController.text),
      kommentar: kommentarController.text,
    );

    await databaseHelper.insertBewohner(neuerBewohner);
    _loadBewohner(); // Liste aktualisieren

    // Formular zurücksetzen
    vornameController.clear();
    nachnameController.clear();
    alterController.clear();
    kommentarController.clear();
  }

  // Bewohner löschen
  void _deleteBewohner(int index) async {
    if (bewohnerListe[index].id != null) {
      await databaseHelper.deleteBewohner(bewohnerListe[index].id!);
      _loadBewohner(); // Liste aktualisieren
    }
  }

  // Bewohner bearbeiten
  void _editBewohner(int index) {
    final bewohner = bewohnerListe[index];
    vornameController.text = bewohner.vorname;
    nachnameController.text = bewohner.nachname;
    alterController.text = bewohner.alter.toString();
    kommentarController.text = bewohner.kommentar;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bewohner bearbeiten'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: vornameController,
                decoration: InputDecoration(labelText: 'Vorname'),
              ),
              TextField(
                controller: nachnameController,
                decoration: InputDecoration(labelText: 'Nachname'),
              ),
              TextField(
                controller: alterController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Alter'),
              ),
              TextField(
                controller: kommentarController,
                decoration: InputDecoration(labelText: 'Kommentar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Speichern'),
              onPressed: () async {
                final bearbeiteterBewohner = Bewohner(
                  id: bewohner.id,
                  vorname: vornameController.text,
                  nachname: nachnameController.text,
                  alter: int.parse(alterController.text),
                  kommentar: kommentarController.text,
                );

                await databaseHelper.updateBewohner(bearbeiteterBewohner);
                _loadBewohner(); // Liste aktualisieren
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bewohner verwalten'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Eingabefelder für Bewohner
                TextField(
                  controller: vornameController,
                  decoration: InputDecoration(labelText: 'Vorname'),
                ),
                TextField(
                  controller: nachnameController,
                  decoration: InputDecoration(labelText: 'Nachname'),
                ),
                TextField(
                  controller: alterController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Alter'),
                ),
                TextField(
                  controller: kommentarController,
                  decoration: InputDecoration(labelText: 'Kommentar'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addBewohner,
                  child: Text('Bewohner hinzufügen'),
                ),
              ],
            ),
          ),
          Divider(),
          // Liste der Bewohner anzeigen
          Expanded(
            child: ListView.builder(
              itemCount: bewohnerListe.length,
              itemBuilder: (context, index) {
                final bewohner = bewohnerListe[index];
                return ListTile(
                  title: Text('${bewohner.vorname} ${bewohner.nachname}'),
                  subtitle: Text('Alter: ${bewohner.alter}\nKommentar: ${bewohner.kommentar}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editBewohner(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteBewohner(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
