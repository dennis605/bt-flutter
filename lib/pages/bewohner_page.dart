import 'package:flutter/material.dart';
import '../models/bewohner_model.dart';
import '../services/database_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BewohnerPage extends StatefulWidget {
  const BewohnerPage({super.key});

  @override
  _BewohnerPageState createState() => _BewohnerPageState();
}

class _BewohnerPageState extends State<BewohnerPage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController alterController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  List<Bewohner> _bewohner = [];

  @override
  void initState() {
    super.initState();
    _loadBewohner();
  }

  Future<void> _loadBewohner() async {
    try {
      final bewohner = _databaseService.getAllBewohner();
      print("Bewohner geladen: $bewohner");
      setState(() {
        _bewohner = bewohner;
      });
    } catch (e) {
      print("Fehler beim Laden der Bewohner: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Laden der Bewohner')),
      );
    }
  }

  Future<void> _addBewohner() async {
    try {
      final neuerBewohner = Bewohner(
        vorname: vornameController.text,
        nachname: nachnameController.text,
        alter: int.parse(alterController.text),
        kommentar: kommentarController.text,
      );

      await _databaseService.addBewohner(neuerBewohner);
      print("Neuer Bewohner hinzugefügt: $neuerBewohner");
      _clearInputs();
      await _loadBewohner();
    } catch (e) {
      print("Fehler beim Hinzufügen des Bewohners: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Hinzufügen des Bewohners')),
      );
    }
  }

  void _clearInputs() {
    vornameController.clear();
    nachnameController.clear();
    alterController.clear();
    kommentarController.clear();
  }

  Future<void> _editBewohner(int index, Bewohner bewohner) async {
    showDialog(
      context: context,
      builder: (context) {
        vornameController.text = bewohner.vorname;
        nachnameController.text = bewohner.nachname;
        alterController.text = bewohner.alter.toString();
        kommentarController.text = bewohner.kommentar;

        return AlertDialog(
          title: const Text('Bewohner bearbeiten'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: vornameController,
                  decoration: const InputDecoration(labelText: 'Vorname'),
                ),
                TextField(
                  controller: nachnameController,
                  decoration: const InputDecoration(labelText: 'Nachname'),
                ),
                TextField(
                  controller: alterController,
                  decoration: const InputDecoration(labelText: 'Alter'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kommentarController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedBewohner = Bewohner(
                    vorname: vornameController.text,
                    nachname: nachnameController.text,
                    alter: int.parse(alterController.text),
                    kommentar: kommentarController.text,
                  );
                  await _databaseService.updateBewohner(index, updatedBewohner);
                  print("Bewohner aktualisiert: $updatedBewohner");
                  Navigator.pop(context);
                  _clearInputs();
                  await _loadBewohner();
                } catch (e) {
                  print("Fehler beim Aktualisieren des Bewohners: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Fehler beim Aktualisieren des Bewohners')),
                  );
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBewohner(int index) async {
    try {
      await _databaseService.deleteBewohner(index);
      print("Bewohner an Index $index gelöscht");
      await _loadBewohner();
    } catch (e) {
      print("Fehler beim Löschen des Bewohners: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fehler beim Löschen des Bewohners')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bewohner verwalten'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: vornameController,
                  decoration: const InputDecoration(labelText: 'Vorname'),
                ),
                TextField(
                  controller: nachnameController,
                  decoration: const InputDecoration(labelText: 'Nachname'),
                ),
                TextField(
                  controller: alterController,
                  decoration: const InputDecoration(labelText: 'Alter'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: kommentarController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addBewohner,
                  child: const Text('Bewohner hinzufügen'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Bewohner>('bewohner').listenable(),
              builder: (context, box, _) {
                return ListView.builder(
                  itemCount: _bewohner.length,
                  itemBuilder: (context, index) {
                    final bewohner = _bewohner[index];
                    return ListTile(
                      title: Text('${bewohner.vorname} ${bewohner.nachname}'),
                      subtitle: Text(
                        'Alter: ${bewohner.alter}\nKommentar: ${bewohner.kommentar}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editBewohner(index, bewohner),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteBewohner(index),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
