import 'package:flutter/material.dart';
import 'absences_screen.dart';
import 'totals_screen.dart';
import 'notes_screen.dart';
import 'moyennes_screen.dart';
import 'top_absences_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Scolarité',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <String, Widget>{
      'Gestion des absences': const AbsencesScreen(),
      'Total des absences + courbe': const TotalsScreen(),
      'Notes et moyennes': const NotesScreen(),
      'Moyennes de la classe': const MoyennesScreen(),
      'Top 3 modules par absences': const TopAbsencesScreen(),
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Scolarité - TP7')),
      body: ListView(children: [
        for (final e in items.entries)
          ListTile(
            title: Text(e.key),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => e.value)),
          ),
      ]),
    );
  }
}
