class Departement {
  final int code;
  final String nom;
  Departement(this.code, this.nom);
  factory Departement.fromJson(Map j) => Departement(j['code'], j['nomDepartement']);
}

class Classe {
  final int codClass;
  final String nomClass;
  Classe(this.codClass, this.nomClass);
  factory Classe.fromJson(Map j) => Classe(j['codClass'], j['nomClass']);
}

class Etudiant {
  final int id;
  final String nom, prenom;
  Etudiant(this.id, this.nom, this.prenom);
  factory Etudiant.fromJson(Map j) => Etudiant(j['id'], j['nom'], j['prenom']);
}

class Matiere {
  final int code;
  final String nom;
  final int coef;
  final int? classeId;
  Matiere(this.code, this.nom, this.coef, this.classeId);
  factory Matiere.fromJson(Map j) => Matiere(
      j['code'], j['nom'], (j['coef'] as num).toInt(),
      (j['classe']?['codClass'] as num?)?.toInt());
}

String _iso(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class Absence {
  final int? id;
  final DateTime dateA;
  final double nha;
  final int etudiantId;
  final Matiere matiere;
  Absence({this.id, required this.dateA, required this.nha,
      required this.etudiantId, required this.matiere});

  factory Absence.fromJson(Map j) => Absence(
      id: j['id'],
      dateA: DateTime.parse(j['dateA'].toString().substring(0, 10)),
      nha: (j['nha'] as num).toDouble(),
      etudiantId: j['etudiant']['id'],
      matiere: Matiere.fromJson(j['matiere']));

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'dateA': _iso(dateA),
        'nha': nha,
        'etudiant': {'id': etudiantId},
        'matiere': {'code': matiere.code},
      };
}

class Note {
  final int? id;
  final double? tp1, tp2, ds, examen;
  final Matiere matiere;
  Note({this.id, this.tp1, this.tp2, this.ds, this.examen, required this.matiere});

  factory Note.fromJson(Map j) => Note(
      id: j['id'],
      tp1: (j['tp1'] as num?)?.toDouble(),
      tp2: (j['tp2'] as num?)?.toDouble(),
      ds: (j['ds'] as num?)?.toDouble(),
      examen: (j['examen'] as num?)?.toDouble(),
      matiere: Matiere.fromJson(j['matiere']));

  bool get isTp => tp1 != null || tp2 != null;

  /// TP : (TP1+TP2)/2  |  cours : 0.3*DS + 0.7*Examen
  double? get moyenne {
    if (isTp) {
      final v = [tp1, tp2].whereType<double>().toList();
      return v.reduce((a, b) => a + b) / v.length;
    }
    if (ds != null && examen != null) return ds! * 0.3 + examen! * 0.7;
    return ds ?? examen;
  }
}
