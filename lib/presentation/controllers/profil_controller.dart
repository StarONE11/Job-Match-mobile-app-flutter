import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/candidat_datasource.dart';

class ProfilController extends GetxController {
  final StorageService _storage;
  final CandidatDataSource _candidatDs;

  ProfilController(
      {required StorageService storage, required CandidatDataSource candidatDs})
      : _storage = storage,
        _candidatDs = candidatDs;

  final RxString nom = ''.obs;
  final RxString metier = ''.obs;
  final RxString ville = ''.obs;
  final RxString email = ''.obs;
  final RxString telephone = ''.obs;

  final RxString nomCv = ''.obs;
  final RxString dateCv = ''.obs;
  final RxBool cvCharge = false.obs;
  final RxString cheminCv = ''.obs;
  final RxBool uploading = false.obs;

  final RxList<String> competences = <String>[].obs;
  final RxInt candidatures = 0.obs;
  final RxInt favorisCount = 0.obs;
  final RxInt entretiens = 0.obs;

  final RxBool alertesActives = true.obs;
  final RxString frequenceAlerte = 'immediat'.obs;
  final RxList<String> motsCles = <String>[].obs;
  final RxString localisationAlerte = ''.obs;
  final RxString typeContratAlerte = 'tous'.obs;

  @override
  void onInit() {
    super.onInit();
    _chargerDepuisStorage();
  }

  void _chargerDepuisStorage() {
    nom.value = _storage.nom.isNotEmpty ? _storage.nom : 'Mon Profil';
    metier.value = _storage.metier.isNotEmpty ? _storage.metier : '';
    ville.value = _storage.ville.isNotEmpty ? _storage.ville : '';
    email.value = _storage.email.isNotEmpty ? _storage.email : '';
    telephone.value = _storage.telephone.isNotEmpty ? _storage.telephone : '';
    cheminCv.value = _storage.cheminCv;
    nomCv.value = _storage.nomCv.isNotEmpty ? _storage.nomCv : '';
    cvCharge.value = _storage.cheminCv.isNotEmpty;
    dateCv.value = cvCharge.value ? 'CV enregistré' : '';
    localisationAlerte.value = ville.value;
    if (metier.value.isNotEmpty) motsCles.add(metier.value);
  }

  Future<void> choisirCv() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null || result.files.single.path == null) return;

    final cheminTemp = result.files.single.path!;
    final nomF = result.files.single.name;
    // Copie vers le répertoire persistant pour survivre aux redémarrages
    final chemin = await _copierCvPersistant(cheminTemp, nomF);

    uploading.value = true;
    try {
      await _candidatDs.matcherCv(cheminFichier: chemin, topK: 1);
      await _storage.sauvegarderCv(chemin: chemin, nom: nomF);
      cheminCv.value = chemin;
      nomCv.value = nomF;
      cvCharge.value = true;
      dateCv.value = 'Mis à jour à l\'instant';
      Get.snackbar('CV mis à jour', 'Votre CV a été analysé avec succès.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      await _storage.sauvegarderCv(chemin: chemin, nom: nomF);
      cheminCv.value = chemin;
      nomCv.value = nomF;
      cvCharge.value = true;
      dateCv.value = 'Enregistré (sync en attente)';
      Get.snackbar('CV enregistré',
          'L\'analyse sera effectuée à la prochaine connexion.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      uploading.value = false;
    }
  }

  /// Copie le fichier source vers documents/ et retourne le chemin permanent.
  Future<String> _copierCvPersistant(String source, String nomFichier) async {
    final docDir = await getApplicationDocumentsDirectory();
    final destination = '${docDir.path}/$nomFichier';
    await File(source).copy(destination);
    return destination;
  }

  Future<void> sauvegarderProfil({
    required String nouveauNom,
    required String nouveauMetier,
    required String nouvelleVille,
    required String nouvelEmail,
    required String nouveauTelephone,
  }) async {
    final n = nouveauNom.trim().isEmpty ? nom.value : nouveauNom.trim();
    final m =
        nouveauMetier.trim().isEmpty ? metier.value : nouveauMetier.trim();
    final v = nouvelleVille.trim().isEmpty ? ville.value : nouvelleVille.trim();
    final e = nouvelEmail.trim().isEmpty ? email.value : nouvelEmail.trim();
    final t = nouveauTelephone.trim().isEmpty
        ? telephone.value
        : nouveauTelephone.trim();
    nom.value = n;
    metier.value = m;
    ville.value = v;
    email.value = e;
    telephone.value = t;
    await _storage.sauvegarderProfil(
        nom: n, metier: m, ville: v, email: e, telephone: t);
    Get.back();
    Get.snackbar('Profil mis à jour', 'Vos modifications ont été sauvegardées.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void ajouterCompetence(String c) {
    if (c.trim().isNotEmpty && !competences.contains(c.trim()))
      competences.add(c.trim());
  }

  void retirerCompetence(String c) => competences.remove(c);

  void sauvegarderAlertes() {
    Get.back();
    Get.snackbar(
        'Alertes mises à jour',
        alertesActives.value
            ? 'Vous recevrez des alertes emploi'
            : 'Les alertes ont été désactivées',
        snackPosition: SnackPosition.BOTTOM);
  }

  void ajouterMotCle(String m) {
    if (m.trim().isNotEmpty && !motsCles.contains(m.trim()))
      motsCles.add(m.trim());
  }

  void retirerMotCle(String m) => motsCles.remove(m);

  Future<void> deconnecter() async {
    await _storage.reinitialiser();
    Get.offAllNamed('/splash');
  }

  String get initiales {
    final mots = nom.value.trim().split(' ');
    if (mots.length >= 2) return '${mots[0][0]}${mots[1][0]}'.toUpperCase();
    if (nom.value.length >= 2) return nom.value.substring(0, 2).toUpperCase();
    return '?';
  }
}
