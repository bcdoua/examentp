import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'api.dart';
import 'models.dart';
import 'student_picker.dart';

class TotalsScreen extends StatefulWidget {
  const TotalsScreen({super.key});
  @override
  State<TotalsScreen> createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> {
  Departement? dep;
  Classe? cls;
  Etudiant? et;
  Map<String, double> totals = {};
  double? grand;

  Future<void> _load() async {
    final abs = await Api.absences(et!.id);
    final m = <String, double>{};
    for (final a in abs) {
      m[a.matiere.nom] = (m[a.matiere.nom] ?? 0) + a.nha;
    }
    if (!mounted) return;
    setState(() { totals = m; grand = null; });
  }

  @override
  Widget build(BuildContext context) {
    final keys = totals.keys.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Total des absences')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          StudentPicker(onSelected: (d, k, e) { dep = d; cls = k; et = e; _load(); }),
          if (et != null) ...[
            Text('Classe : ${cls!.nomClass}     Département : ${dep!.nom}'),
            Text('Étudiant : ${et!.id}   Nom : ${et!.nom}   Prénom : ${et!.prenom}'),
            DataTable(
              columns: const [
                DataColumn(label: Text('CodMat')),
                DataColumn(label: Text('Total NHA')),
              ],
              rows: [
                for (final k in keys)
                  DataRow(cells: [DataCell(Text(k)), DataCell(Text('${totals[k]}'))]),
              ],
            ),
            ElevatedButton(
              onPressed: () => setState(
                  () => grand = totals.values.fold<double>(0, (a, b) => a + b)),
              child: const Text('Calculer'),
            ),
            if (grand != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Total des absences / semestre : $grand',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: 16),
            if (keys.isNotEmpty)
              SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: LineChart(LineChartData(
                    minY: 0,
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (v, meta) {
                            final i = v.toInt();
                            return i >= 0 && i < keys.length && v == i.toDouble()
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(keys[i]))
                                : const SizedBox();
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                        spots: [
                          for (var i = 0; i < keys.length; i++)
                            FlSpot(i.toDouble(), totals[keys[i]]!),
                        ],
                      ),
                    ],
                  )),
                ),
              ),
          ],
        ]),
      ),
    );
  }
}
