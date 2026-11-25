import 'package:flutter/material.dart';
import 'api.dart';

class TopAbsencesScreen extends StatefulWidget {
  const TopAbsencesScreen({super.key});
  @override
  State<TopAbsencesScreen> createState() => _TopAbsencesScreenState();
}

class _TopAbsencesScreenState extends State<TopAbsencesScreen> {
  List<MapEntry<String, double>> top = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final abs = await Api.allAbsences();
      final m = <String, double>{};
      for (final a in abs) {
        m[a.matiere.nom] = (m[a.matiere.nom] ?? 0) + a.nha;
      }
      final sorted = m.entries.toList()
        ..sort((x, y) => y.value.compareTo(x.value));
      if (!mounted) return;
      setState(() {
        top = sorted.take(3).toList();
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { error = 'Erreur : $e'; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 3 des modules par absences')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Text(error!, style: const TextStyle(color: Colors.red))
            : top.isEmpty
            ? const Text('Aucune absence enregistrée.')
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Rang')),
              DataColumn(label: Text('Module (intitulé)')),
              DataColumn(label: Text('Total NHA')),
            ],
            rows: [
              for (var i = 0; i < top.length; i++)
                DataRow(cells: [
                  DataCell(Text('${i + 1}')),
                  DataCell(Text(top[i].key)),
                  DataCell(Text(top[i].value.toStringAsFixed(1))),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}