import 'package:flutter/material.dart';
import 'package:myapp/services/database_service.dart';
import 'pages/bewohner_page.dart';
import 'pages/betreuer_page.dart';
import 'pages/veranstaltung_page.dart';
import 'pages/tagesplan_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/bewohner_model.dart';
import 'models/betreuer_model.dart';
import 'models/veranstaltung_model.dart';
import 'models/tagesplan_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialisiere Hive für Web
    await Hive.initFlutter();
    
    // Registriere Adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BewohnerAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BetreuerAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(VeranstaltungAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TagesplanAdapter());
    }
    
    // Öffne Boxen
    final bewohnerBox = await Hive.openBox<Bewohner>(
      'bewohner',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 50;
      },
    );
    
    // Füge einen Test-Bewohner hinzu, wenn die Box leer ist
    if (bewohnerBox.isEmpty) {
      print('Box ist leer, füge Test-Bewohner hinzu');
      final testBewohner = Bewohner(
        vorname: 'Test',
        nachname: 'Bewohner',
        alter: 30,
        kommentar: 'Test Eintrag',
      );
      await bewohnerBox.put('test', testBewohner);
      await bewohnerBox.flush();
    }
    
    // Öffne andere Boxen
    await Hive.openBox<Betreuer>('betreuer');
    await Hive.openBox<Veranstaltung>('veranstaltung');
    await Hive.openBox<Tagesplan>('tagesplan');
    
    // Überprüfe die Box
    print('Hive wurde erfolgreich initialisiert');
    print('Bewohner Box Status:');
    print('- Ist geöffnet: ${bewohnerBox.isOpen}');
    print('- Anzahl Einträge: ${bewohnerBox.length}');
    print('- Alle Einträge: ${bewohnerBox.values.toList()}');
    print('- Box Name: ${bewohnerBox.name}');
    print('- Box Keys: ${bewohnerBox.keys.toList()}');
    
    // Erzwinge das Speichern
    await bewohnerBox.compact();
    await bewohnerBox.flush();
    
  } catch (e, stackTrace) {
    print('Fehler bei der Hive-Initialisierung: $e');
    print('Stacktrace: $stackTrace');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'CRUD App Menü',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Bewohner verwalten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BewohnerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervisor_account),
              title: const Text('Betreuer verwalten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BetreuerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Veranstaltungen verwalten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VeranstaltungPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Tagespläne verwalten'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TagesplanPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Willkommen zur CRUD-App',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
