import 'package:flutter/material.dart';
import 'api.dart';
import 'models.dart';

/// Trois listes liees : Departements -> Classes -> Etudiants.
class StudentPicker extends StatefulWidget {
  final void Function(Departement, Classe, Etudiant) onSelected;
  const StudentPicker({super.key, required this.onSelected});
  @override
  State<StudentPicker> createState() => _StudentPickerState();
}

class _StudentPickerState extends State<StudentPicker> {
  List<Departement> deps = [];
  List<Classe> classes = [];
  List<Etudiant> etuds = [];
  Departement? dep;
  Classe? cls;
  Etudiant? et;
  String? error;

  @override
  void initState() {
    super.initState();
    Api.departements()
        .then((v) => setState(() => deps = v))
        .catchError((e) => setState(() => error = 'Backend injoignable : $e'));
  }

  Widget _box<T>(String title, List<T> items, T? sel, String Function(T) label,
          void Function(T) tap) =>
      Expanded(
        child: Column(children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 130,
            child: Card(
              child: ListView(children: [
                for (final e in items)
                  ListTile(
                      dense: true,
                      selected: identical(e, sel),
                      title: Text(label(e)),
                      onTap: () => tap(e)),
              ]),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (error != null)
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(error!, style: const TextStyle(color: Colors.red))),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _box<Departement>('Départements', deps, dep, (d) => d.nom, (d) {
          setState(() {
            dep = d; cls = null; et = null; classes = []; etuds = [];
          });
          Api.classes(d.code).then((v) => setState(() => classes = v));
        }),
        _box<Classe>('Classes', classes, cls, (x) => x.nomClass, (x) {
          setState(() { cls = x; et = null; etuds = []; });
          Api.etudiants(x.codClass).then((v) => setState(() => etuds = v));
        }),
        _box<Etudiant>('Étudiants', etuds, et, (x) => x.nom, (x) {
          setState(() => et = x);
          widget.onSelected(dep!, cls!, x);
        }),
      ]),
    ]);
  }
}
