import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class Api {
  /// Telephone reel : mettre l'IP du PC, ex. 'http://192.168.1.20:8081'
  static String? override;
  static Future<List<Absence>> allAbsences() async =>
      (await _list('/absence/all')).map((e) => Absence.fromJson(e)).toList();

  static String get base {
    if (override != null) return override!;
    if (kIsWeb) return 'http://localhost:8081';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8081';
    return 'http://localhost:8081';
  }

  static Future<List> _list(String p) async {
    final r = await http.get(Uri.parse('$base$p'));
    if (r.statusCode != 200) throw Exception('HTTP ${r.statusCode} sur $p');
    return jsonDecode(utf8.decode(r.bodyBytes)) as List;
  }

  static Future<void> _send(String m, String p, Map body) async {
    final req = http.Request(m, Uri.parse('$base$p'))
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode(body);
    final r = await http.Response.fromStream(await req.send());
    if (r.statusCode >= 300) throw Exception('HTTP ${r.statusCode} sur $p');
  }

  static Future<List<Departement>> departements() async =>
      (await _list('/departement/all')).map((e) => Departement.fromJson(e)).toList();

  static Future<List<Classe>> classes(int dep) async =>
      (await _list('/class/findByDepId/$dep')).map((e) => Classe.fromJson(e)).toList();

  static Future<List<Etudiant>> etudiants(int cls) async =>
      (await _list('/etudiant/findByClasseId/$cls')).map((e) => Etudiant.fromJson(e)).toList();

  static Future<List<Matiere>> matieres(int cls) async =>
      (await _list('/matiere/findByClasseId/$cls')).map((e) => Matiere.fromJson(e)).toList();

  static Future<List<Absence>> absences(int et) async =>
      (await _list('/absence/findByEtudiantId/$et')).map((e) => Absence.fromJson(e)).toList();

  static Future<List<Note>> notes(int et) async =>
      (await _list('/note/findByEtudiantId/$et')).map((e) => Note.fromJson(e)).toList();

  static Future<void> addAbsence(Absence a) => _send('POST', '/absence/add', a.toJson());
  static Future<void> updateAbsence(Absence a) => _send('PUT', '/absence/update', a.toJson());

  static Future<void> deleteAbsence(int id) async {
    final r = await http.delete(Uri.parse('$base/absence/delete?id=$id'));
    if (r.statusCode >= 300) throw Exception('HTTP ${r.statusCode}');
  }
}
