import 'package:flutter/material.dart';
import 'bewohner_page.dart';
import 'betreuer_page.dart';
import 'veranstaltung_page.dart';
import 'tagesplan_page.dart'; // Importiere die Tagesplan-Seite

void main() {
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
                Navigator.pop(context); // Schließt den Drawer
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
                  MaterialPageRoute(builder: (context) => const VeranstaltungPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Tagespläne verwalten'), // Neuer Eintrag für Tagespläne
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TagesplanPage()), // Zur Tagesplan-Seite navigieren
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
