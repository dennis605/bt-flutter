import 'package:flutter/material.dart';
import 'betreuer_model.dart'; // Importiere das Betreuer-Modell
import 'database_helper.dart'; // Importiere den Datenbankhelper

class BetreuerPage extends StatefulWidget {
  const BetreuerPage({super.key});

  @override
  _BetreuerPageState createState() => _BetreuerPageState();
}

class _BetreuerPageState extends State<BetreuerPage> {
  // Liste der Betreuer
  List<Betreuer> betreuerListe = [];
  final DatabaseHelper databaseHelper = DatabaseHelper();

  // Controller für das Formular
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBetreuer();
  }

  // Betreuer laden
  void _loadBetreuer() async {
    betreuerListe = await databaseHelper.getBetreuer();
    setState(() {});
  }

  // Betreuer hinzufügen
  void _addBetreuer() async {
    final neuerBetreuer = Betreuer(
      vorname: vornameController.text,
      nachname: nachnameController.text,
      kommentar: kommentarController.text,
    );

    await databaseHelper.insertBetreuer(neuerBetreuer);
    _loadBetreuer(); // Liste aktualisieren

    // Formular zurücksetzen
    vornameController.clear();
    nachnameController.clear();
    kommentarController.clear();
  }

  // Betreuer löschen
  void _deleteBetreuer(int index) async {
    if (betreuerListe[index].id != null) {
      await databaseHelper.deleteBetreuer(betreuerListe[index].id!);
      _loadBetreuer(); // Liste aktualisieren
    }
  }

  // Betreuer bearbeiten
  void _editBetreuer(int index) {
    final betreuer = betreuerListe[index];
    vornameController.text = betreuer.vorname;
    nachnameController.text = betreuer.nachname;
    kommentarController.text = betreuer.kommentar;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Betreuer bearbeiten'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: vornameController,
                decoration: const InputDecoration(labelText: 'Vorname'),
              ),
              TextField(
                controller: nachnameController,
                decoration: const InputDecoration(labelText: 'Nachname'),
              ),
              TextField(
                controller: kommentarController,
                decoration: const InputDecoration(labelText: 'Kommentar'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Speichern'),
              onPressed: () async {
                final bearbeiteterBetreuer = Betreuer(
                  id: betreuer.id,
                  vorname: vornameController.text,
                  nachname: nachnameController.text,
                  kommentar: kommentarController.text,
                );

                await databaseHelper.updateBetreuer(bearbeiteterBetreuer);
                _loadBetreuer(); // Liste aktualisieren
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
        title: const Text('Betreuer verwalten'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Eingabefelder für Betreuer
                TextField(
                  controller: vornameController,
                  decoration: const InputDecoration(labelText: 'Vorname'),
                ),
                TextField(
                  controller: nachnameController,
                  decoration: const InputDecoration(labelText: 'Nachname'),
                ),
                TextField(
                  controller: kommentarController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addBetreuer,
                  child: const Text('Betreuer hinzufügen'),
                ),
              ],
            ),
          ),
          const Divider(),
          // Liste der Betreuer anzeigen
          Expanded(
            child: ListView.builder(
              itemCount: betreuerListe.length,
              itemBuilder: (context, index) {
                final betreuer = betreuerListe[index];
                return ListTile(
                  title: Text('${betreuer.vorname} ${betreuer.nachname}'),
                  subtitle: Text('Kommentar: ${betreuer.kommentar}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editBetreuer(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteBetreuer(index);
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
