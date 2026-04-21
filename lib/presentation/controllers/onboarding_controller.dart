import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/candidat_datasource.dart';
import '../../../domain/entities/offre_emploi.dart';

enum EtapeOnboarding { profil, cv, traitement }

class OnboardingController extends GetxController {
  final StorageService _storage;
  final CandidatDataSource _candidatDs;

  OnboardingController(
      {required StorageService storage, required CandidatDataSource candidatDs})
      : _storage = storage,
        _candidatDs = candidatDs;

  // ── État des étapes ─────────────────────────────────────────────────────────
  final Rx<EtapeOnboarding> etape = EtapeOnboarding.profil.obs;

  // ── Formulaire étape 1 ──────────────────────────────────────────────────────
  final RxString nom = ''.obs;
  final RxString metier = ''.obs;
  final RxString ville = ''.obs;
  final RxString email = ''.obs;
  final RxString telephone = ''.obs;

  // ── CV étape 2 ──────────────────────────────────────────────────────────────
  final RxString cheminCv = ''.obs;
  final RxString nomCv = ''.obs;

  // ── Traitement étape 3 ──────────────────────────────────────────────────────
  final RxBool enTraitement = false.obs;
  final RxString messageEtat = ''.obs;
  final RxString erreur = ''.obs;
  final RxList<OffreEmploi> recommandations = <OffreEmploi>[].obs;

  // ── Validation étape 1 ──────────────────────────────────────────────────────
  bool get etape1Valide =>
      nom.value.trim().isNotEmpty &&
      metier.value.trim().isNotEmpty &&
      ville.value.trim().isNotEmpty;

  void validerEtape1() {
    if (!etape1Valide) {
      Get.snackbar(
          'Champs requis', 'Veuillez remplir le nom, le métier et la ville.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    etape.value = EtapeOnboarding.cv;
  }

  // ── Sélection du CV ─────────────────────────────────────────────────────────
  Future<void> choisirCv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final cheminTemp = result.files.single.path!;
      final nom = result.files.single.name;
      // Copie vers le répertoire persistant pour survivre aux redémarrages
      final cheminPersistant = await _copierCvPersistant(cheminTemp, nom);
      cheminCv.value = cheminPersistant;
      nomCv.value = nom;
    }
  }

  /// Copie le fichier source vers documents/ et retourne le chemin permanent.
  Future<String> _copierCvPersistant(String source, String nomFichier) async {
    final docDir = await getApplicationDocumentsDirectory();
    final destination = '${docDir.path}/$nomFichier';
    await File(source).copy(destination);
    return destination;
  }

  void ignorerCv() {
    cheminCv.value = '';
    nomCv.value = '';
    _finaliserSansMatching();
  }

  Future<void> validerEtape2() async {
    if (cheminCv.value.isEmpty) {
      Get.snackbar('Aucun CV', 'Sélectionnez un PDF ou ignorez cette étape.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    etape.value = EtapeOnboarding.traitement;
    await _lancerMatching();
  }

  // ── Matching ────────────────────────────────────────────────────────────────
  Future<void> _lancerMatching() async {
    enTraitement.value = true;
    erreur.value = '';
    messageEtat.value = 'Analyse de votre CV…';

    try {
      messageEtat.value = 'Recherche des offres correspondantes…';
      final result =
          await _candidatDs.matcherCv(cheminFichier: cheminCv.value, topK: 20);
      recommandations.assignAll(result.jobs);
      messageEtat.value = '${result.totalMatched} offres trouvées !';
      await _sauvegarderEtTerminer();
    } catch (e) {
      erreur.value =
          'Impossible d\'analyser le CV. Vous pourrez le faire plus tard depuis votre profil.';
      await _finaliserSansMatching();
    } finally {
      enTraitement.value = false;
    }
  }

  // ── Sauvegarde et redirection ────────────────────────────────────────────────
  Future<void> _sauvegarderEtTerminer() async {
    await _storage.sauvegarderProfil(
      nom: nom.value.trim(),
      metier: metier.value.trim(),
      ville: ville.value.trim(),
      email: email.value.trim(),
      telephone: telephone.value.trim(),
    );
    if (cheminCv.value.isNotEmpty) {
      await _storage.sauvegarderCv(chemin: cheminCv.value, nom: nomCv.value);
    }
    await _storage.marquerInscrit();
    // Passer les recommandations à la home via GetX arguments
    Get.offAllNamed('/home',
        arguments: {'recommandations': recommandations.toList()});
  }

  Future<void> _finaliserSansMatching() async {
    await _storage.sauvegarderProfil(
      nom: nom.value.trim(),
      metier: metier.value.trim(),
      ville: ville.value.trim(),
      email: email.value.trim(),
      telephone: telephone.value.trim(),
    );
    if (cheminCv.value.isNotEmpty) {
      await _storage.sauvegarderCv(chemin: cheminCv.value, nom: nomCv.value);
    }
    await _storage.marquerInscrit();
    Get.offAllNamed('/home');
  }

  void retourEtape1() => etape.value = EtapeOnboarding.profil;
  void retourEtape2() => etape.value = EtapeOnboarding.cv;
}
