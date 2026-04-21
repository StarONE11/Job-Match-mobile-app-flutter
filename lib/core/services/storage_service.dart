import 'package:shared_preferences/shared_preferences.dart';

/// Stockage local de l'utilisateur (SharedPreferences).
/// Clé unique par donnée — jamais de données sensibles en clair.
class StorageService {
  static const _kInscrit = 'inscrit';
  static const _kNom = 'profil_nom';
  static const _kMetier = 'profil_metier';
  static const _kVille = 'profil_ville';
  static const _kEmail = 'profil_email';
  static const _kTelephone = 'profil_telephone';
  static const _kCheminCv = 'profil_chemin_cv';
  static const _kNomCv = 'profil_nom_cv';

  final SharedPreferences _prefs;
  StorageService._(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  // ── Inscription ─────────────────────────────────────────────────────────────
  bool get estInscrit => _prefs.getBool(_kInscrit) ?? false;
  Future<void> marquerInscrit() => _prefs.setBool(_kInscrit, true);
  Future<void> reinitialiser() => _prefs.clear();

  // ── Profil ──────────────────────────────────────────────────────────────────
  String get nom => _prefs.getString(_kNom) ?? '';
  String get metier => _prefs.getString(_kMetier) ?? '';
  String get ville => _prefs.getString(_kVille) ?? '';
  String get email => _prefs.getString(_kEmail) ?? '';
  String get telephone => _prefs.getString(_kTelephone) ?? '';
  String get cheminCv => _prefs.getString(_kCheminCv) ?? '';
  String get nomCv => _prefs.getString(_kNomCv) ?? '';

  Future<void> sauvegarderProfil({
    required String nom,
    required String metier,
    required String ville,
    required String email,
    required String telephone,
  }) async {
    await _prefs.setString(_kNom, nom);
    await _prefs.setString(_kMetier, metier);
    await _prefs.setString(_kVille, ville);
    await _prefs.setString(_kEmail, email);
    await _prefs.setString(_kTelephone, telephone);
  }

  Future<void> sauvegarderCv({
    required String chemin,
    required String nom,
  }) async {
    await _prefs.setString(_kCheminCv, chemin);
    await _prefs.setString(_kNomCv, nom);
  }
}
