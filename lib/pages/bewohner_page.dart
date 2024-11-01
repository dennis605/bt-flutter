import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bewohner_model.dart';

class BewohnerPage extends StatefulWidget {
  const BewohnerPage({super.key});

  @override
  _BewohnerPageState createState() => _BewohnerPageState();
}

class _BewohnerPageState extends State<BewohnerPage> {
  final _bewohnerBox = Hive.box<Bewohner>('bewohner');
  
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController alterController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  void _addBewohner() {
    final neuerBewohner = Bewohner(
      vorname: vornameController.text,
      nachname: nachnameController.text,
      alter: int.parse(alterController.text),
      kommentar: kommentarController.text,
    );

    _bewohnerBox.add(neuerBewohner);
    _clearInputs();
  }

  void _clearInputs() {
    vornameController.clear();
    nachnameController.clear();
    alterController.clear();
    kommentarController.clear();
  }

  void _editBewohner(int index, Bewohner bewohner) {
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
              onPressed: () {
                final updatedBewohner = Bewohner(
                  vorname: vornameController.text,
                  nachname: nachnameController.text,
                  alter: int.parse(alterController.text),
                  kommentar: kommentarController.text,
                );
                _bewohnerBox.putAt(index, updatedBewohner);
                Navigator.pop(context);
                _clearInputs();
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBewohner(int index) {
    _bewohnerBox.deleteAt(index);
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
              valueListenable: _bewohnerBox.listenable(),
              builder: (context, Box<Bewohner> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final bewohner = box.getAt(index);
                    return ListTile(
                      title: Text('${bewohner?.vorname} ${bewohner?.nachname}'),
                      subtitle: Text(
                        'Alter: ${bewohner?.alter}\nKommentar: ${bewohner?.kommentar}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editBewohner(index, bewohner!),
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