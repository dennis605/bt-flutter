
import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/betreuer_model.dart';
import 'package:hive/hive.dart';


class BetreuerPage extends StatefulWidget {
  const BetreuerPage({super.key});

  @override
  _BetreuerPageState createState() => _BetreuerPageState();
}

class _BetreuerPageState extends State<BetreuerPage> {
  final _betreuerBox = Hive.box<Betreuer>('betreuer');
  
  final TextEditingController vornameController = TextEditingController();
  final TextEditingController nachnameController = TextEditingController();
  final TextEditingController kommentarController = TextEditingController();

  void _addBetreuer() {
    final neuerBetreuer = Betreuer(
      vorname: vornameController.text,
      nachname: nachnameController.text,
      kommentar: kommentarController.text,
    );

    _betreuerBox.add(neuerBetreuer);
    _clearInputs();
  }

  void _clearInputs() {
    vornameController.clear();
    nachnameController.clear();
    kommentarController.clear();
  }

  void _editBetreuer(int index, Betreuer betreuer) {
    showDialog(
      context: context,
      builder: (context) {
        vornameController.text = betreuer.vorname;
        nachnameController.text = betreuer.nachname;
        kommentarController.text = betreuer.kommentar;

        return AlertDialog(
          title: const Text('Betreuer bearbeiten'),
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
                final updatedBetreuer = Betreuer(
                  vorname: vornameController.text,
                  nachname: nachnameController.text,
                  kommentar: kommentarController.text,
                );
                _betreuerBox.putAt(index, updatedBetreuer);
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

  void _deleteBetreuer(int index) {
    _betreuerBox.deleteAt(index);
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
                  controller: kommentarController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addBetreuer,
                  child: const Text('Betreuer hinzufügen'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _betreuerBox.listenable(),
              builder: (context, Box<Betreuer> box, _) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final betreuer = box.getAt(index);
                    return ListTile(
                      title: Text('${betreuer?.vorname} ${betreuer?.nachname}'),
                      subtitle: Text('Kommentar: ${betreuer?.kommentar}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editBetreuer(index, betreuer!),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteBetreuer(index),
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