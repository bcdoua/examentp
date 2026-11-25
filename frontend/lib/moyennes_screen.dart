import 'package:flutter/material.dart';
import 'api.dart';
import 'models.dart';

class MoyennesScreen extends StatefulWidget {
  const MoyennesScreen({super.key});
  @override
  State<MoyennesScreen> createState() => _MoyennesScreenState();
}

class _MoyennesScreenState extends State<MoyennesScreen> {
  List<Departement> deps = [];
  List<Classe> classes = [];
  Departement? dep;
  Classe? cls;
  List<MapEntry<Etudiant, double?>> rows = [];
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    Api.departements().then((v) {
      if (mounted) setState(() => deps = v);
    }).catchError((e) {
      if (mounted) setState(() => error = 'Backend injoignable : $e');
    });
  }

  String _date() {
    final d = DateTime.now();
    return '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
  }

  String _f(double? v) => v == null ? '-' : v.toStringAsFixed(2);

  /// Moyenne générale pondérée par le coef (même règle que notes_screen.dart)
  double? _general(List<Note> notes) {
    double s = 0, k = 0;
    for (final n in notes) {
      final m = n.moyenne;
      if (m != null) {
        s += m * n.matiere.coef;
        k += n.matiere.coef;
      }
    }
    return k == 0 ? null : s / k;
  }

  Future<void> _chargerClasses(Departement d) async {
    setState(() {
      dep = d;
      cls = null;
      classes = [];
      rows = [];
      error = null;
    });
    try {
      final v = await Api.classes(d.code);
      if (mounted) setState(() => classes = v);
    } catch (e) {
      if (mounted) setState(() => error = 'Erreur : $e');
    }
  }

  Future<void> _chargerMoyennes(Classe c) async {
    setState(() {
      cls = c;
      rows = [];
      loading = true;
      error = null;
    });
    try {
      final etuds = await Api.etudiants(c.codClass);
      final notes = await Future.wait(etuds.map((e) => Api.notes(e.id)));
      if (!mounted) return;
      setState(() {
        rows = [
          for (var i = 0; i < etuds.length; i++)
            MapEntry(etuds[i], _general(notes[i]))
        ];
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { error = 'Erreur : $e'; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moyennes de la classe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownButton<Departement>(
            isExpanded: true,
            hint: const Text('Choisir un département'),
            value: dep,
            items: [
              for (final d in deps) DropdownMenuItem(value: d, child: Text(d.nom))
            ],
            onChanged: (d) { if (d != null) _chargerClasses(d); },
          ),
          DropdownButton<Classe>(
            isExpanded: true,
            hint: const Text('Choisir une classe'),
            value: cls,
            items: [
              for (final c in classes) DropdownMenuItem(value: c, child: Text(c.nomClass))
            ],
            onChanged: (c) { if (c != null) _chargerMoyennes(c); },
          ),
          if (error != null)
            Text(error!, style: const TextStyle(color: Colors.red)),
          if (loading)
            const Center(child: Padding(
                padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
          if (cls != null && !loading) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Classe : ${cls!.nomClass}    Département : ${dep!.nom}    Date : ${_date()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (rows.isEmpty)
              const Text('Aucun étudiant dans cette classe.')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Prenom')),
                    DataColumn(label: Text('Moyenne')),
                  ],
                  rows: [
                    for (final r in rows)
                      DataRow(cells: [
                        DataCell(Text(r.key.nom)),
                        DataCell(Text(r.key.prenom)),
                        DataCell(Text(_f(r.value))),
                      ]),
                  ],
                ),
              ),
          ],
        ]),
      ),
    );
  }
}