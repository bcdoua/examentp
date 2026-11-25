import 'package:flutter/material.dart';
import 'api.dart';
import 'models.dart';
import 'student_picker.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});
  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  Classe? cls;
  Etudiant? et;
  List<Absence> abs = [];
  List<Matiere> mats = [];
  final nom = TextEditingController();
  final prenom = TextEditingController();

  Future<void> _load() async {
    final a = await Api.absences(et!.id);
    final m = await Api.matieres(cls!.codClass);
    if (!mounted) return;
    setState(() { abs = a; mats = m; });
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _edit([Absence? a]) async {
    if (et == null) { _msg('Sélectionnez d\'abord un étudiant'); return; }
    if (mats.isEmpty) { _msg('Cette classe n\'a aucune matière'); return; }

    Matiere mat = mats.first;
    if (a != null) {
      mat = mats.firstWhere((m) => m.code == a.matiere.code, orElse: () => mats.first);
    }
    DateTime date = a?.dateA ?? DateTime.now();
    final nha = TextEditingController(text: a?.nha.toString() ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(a == null ? 'Ajouter une absence' : 'Modifier l\'absence'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButton<Matiere>(
              isExpanded: true,
              value: mat,
              items: [for (final m in mats) DropdownMenuItem(value: m, child: Text(m.nom))],
              onChanged: (v) => setD(() => mat = v!),
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_fmt(date)),
              onPressed: () async {
                final d = await showDatePicker(
                    context: ctx, initialDate: date,
                    firstDate: DateTime(2020), lastDate: DateTime(2100));
                if (d != null) setD(() => date = d);
              },
            ),
            TextField(
              controller: nha,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'NHA (heures)'),
            ),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
    if (ok != true) return;

    final h = double.tryParse(nha.text.replaceAll(',', '.'));
    if (h == null) { _msg('NHA invalide'); return; }

    final x = Absence(id: a?.id, dateA: date, nha: h, etudiantId: et!.id, matiere: mat);
    try {
      if (a == null) {
        await Api.addAbsence(x);
      } else {
        await Api.updateAbsence(x);
      }
      await _load();
    } catch (e) {
      _msg('Erreur : $e');
    }
  }

  Future<void> _delete(Absence a) async {
    try {
      await Api.deleteAbsence(a.id!);
      await _load();
    } catch (e) {
      _msg('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Gestion des absences')),
        floatingActionButton:
            FloatingActionButton(onPressed: () => _edit(), child: const Icon(Icons.add)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            StudentPicker(onSelected: (d, k, e) {
              cls = k; et = e;
              nom.text = e.nom; prenom.text = e.prenom;
              _load();
            }),
            Row(children: [
              Expanded(child: TextField(controller: nom, readOnly: true,
                  decoration: const InputDecoration(labelText: 'Nom'))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: prenom, readOnly: true,
                  decoration: const InputDecoration(labelText: 'Prénom'))),
            ]),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('DateA')),
                  DataColumn(label: Text('CodMat')),
                  DataColumn(label: Text('NHA')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  for (final a in abs)
                    DataRow(cells: [
                      DataCell(Text(_fmt(a.dateA))),
                      DataCell(Text(a.matiere.nom)),
                      DataCell(Text('${a.nha}')),
                      DataCell(Row(children: [
                        IconButton(icon: const Icon(Icons.edit), tooltip: 'Mettre à jour',
                            onPressed: () => _edit(a)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Supprimer', onPressed: () => _delete(a)),
                      ])),
                    ]),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ]),
        ),
      );
}
