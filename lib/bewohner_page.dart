import 'package:flutter/material.dart';
import 'bewohner_model.dart'; // Importiere das Bewohnermodell

class BewohnerPage extends StatefulWidget {
  @override
  _BewohnerPageState createState() => _BewohnerPageState();
}

class _BewohnerPageState extends State<BewohnerPage> {
  // Liste der Bewohner
  List<Bewohner> bewohnerListe = [];

  // Controller für das Formular
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController alterController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  // Bewohner hinzufügen
  void _addBewohner() {
    setState(() {
      bewohnerListe.add(Bewohner(
        vorname: vornameController.text,
        nachname: nachnameController.text,
        alter: int.parse(alterController.text),
        kommentar: kommentarController.text,
      ));
    });

    // Formular zurücksetzen
    vornameController.clear();
    nachnameController.clear();
    alterController.clear();
    kommentarController.clear();
  
  }


  // Bewohner löschen
  void _deleteBewohner(int index) {
    setState(() {
      bewohnerListe.removeAt(index);
    });
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
              onPressed: () {
                setState(() {
                  bewohnerListe[index] = Bewohner(
                    vorname: vornameController.text,
                    nachname: nachnameController.text,
                    alter: int.parse(alterController.text),
                    kommentar: kommentarController.text,
                  );
                });
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
