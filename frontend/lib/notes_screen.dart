import 'package:flutter/material.dart';
import 'api.dart';
import 'models.dart';
import 'student_picker.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Departement? dep;
  Classe? cls;
  Etudiant? et;
  List<Note> notes = [];


  double? get general {
    double s = 0, k = 0;
    for (final n in notes) {
      final m = n.moyenne;
      if (m != null) { s += m * n.matiere.coef; k += n.matiere.coef; }
    }
    return k == 0 ? null : s / k;
  }

  String _f(double? v) => v == null ? '-' : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    const titres = ['Module', 'TP1', 'TP2', 'DS', 'Exam', 'Moyenne'];
    return Scaffold(
      appBar: AppBar(title: const Text('Moyennes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          StudentPicker(onSelected: (d, k, e) async {
            dep = d; cls = k; et = e;
            final n = await Api.notes(e.id);
            if (!mounted) return;
            setState(() => notes = n);
          }),
          if (et != null) ...[
            Text('Classe : ${cls!.nomClass}     Département : ${dep!.nom}'),
            Text('Étudiant : ${et!.id}   Nom : ${et!.nom}   Prénom : ${et!.prenom}'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [for (final t in titres) DataColumn(label: Text(t))],
                rows: [
                  for (final n in notes)
                    DataRow(cells: [
                      DataCell(Text(n.matiere.nom)),
                      DataCell(Text(_f(n.tp1))),
                      DataCell(Text(_f(n.tp2))),
                      DataCell(Text(_f(n.ds))),
                      DataCell(Text(_f(n.examen))),
                      DataCell(Text(_f(n.moyenne))),
                    ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Moyenne générale : ${_f(general)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ]),
      ),
    );
  }
}
