import 'dart:io';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../data/datasources/candidat_datasource.dart';
import '../../domain/entities/offre_emploi.dart';
import '../../domain/usecases/offre_usecases.dart';

class HomeController extends GetxController {
  final VoirLesOffres _voirLesOffres;
  final ChercherOffres _chercherOffres;
  final VoirStats _voirStats;
  final StorageService _storage;
  final CandidatDataSource _candidatDs;

  HomeController({
    required VoirLesOffres voirLesOffres,
    required ChercherOffres chercherOffres,
    required VoirStats voirStats,
    required StorageService storage,
    required CandidatDataSource candidatDs,
  })  : _voirLesOffres = voirLesOffres,
        _chercherOffres = chercherOffres,
        _voirStats = voirStats,
        _storage = storage,
        _candidatDs = candidatDs;

  final RxList<OffreEmploi> offres = <OffreEmploi>[].obs;
  final RxList<OffreEmploi> recommandations = <OffreEmploi>[].obs;
  final RxBool chargement = false.obs;
  final RxBool chargementPlus = false.obs;
  final RxBool chargementReco = false.obs;
  final RxString erreur = ''.obs;
  final RxString erreurReco = ''.obs;
  final RxString ongletActif = 'toutes'.obs;
  final RxInt totalOffres = 0.obs;
  final RxBool plusDOffres = true.obs;

  bool get aRecommandations => recommandations.isNotEmpty;
  bool get aCv => _storage.cheminCv.isNotEmpty;

  int _page = 0;
  static const int _limite = 20;

  @override
  void onInit() {
    super.onInit();
    // 1. Recommandations passées directement depuis l'onboarding
    final args = Get.arguments;
    if (args is Map && args['recommandations'] is List) {
      final recs = (args['recommandations'] as List).cast<OffreEmploi>();
      if (recs.isNotEmpty) {
        recommandations.assignAll(recs);
        ongletActif.value = 'recommandees';
      }
    }
    // 2. Toujours lancer le matching si un CV existe
    //    (couvre le cas retour après 1ère inscription)
    if (recommandations.isEmpty && aCv) {
      ongletActif.value = 'recommandees';
      chargerRecommandations();
    }
    chargerOffres();
    chargerStats();
  }

  // ── Recommandations basées sur le CV ───────────────────────────────────────
  Future<void> chargerRecommandations() async {
    if (!aCv) return;
    // Vérification que le fichier existe encore (chemin persistant)
    if (!File(_storage.cheminCv).existsSync()) {
      // Chemin obsolète (ancienne install, fichier temp supprimé)
      await _storage.sauvegarderCv(chemin: '', nom: '');
      erreurReco.value = 'CV introuvable. Re-uploadez votre CV dans le profil.';
      ongletActif.value = 'toutes';
      return;
    }
    chargementReco.value = true;
    erreurReco.value = '';
    try {
      final result = await _candidatDs.matcherCv(
        cheminFichier: _storage.cheminCv,
        topK: 20,
      );
      recommandations.assignAll(result.jobs);
    } catch (e) {
      erreurReco.value = 'Impossible de charger les recommandations.';
      // En cas d'erreur, basculer sur l'onglet toutes
      if (ongletActif.value == 'recommandees') ongletActif.value = 'toutes';
    } finally {
      chargementReco.value = false;
    }
  }

  Future<void> chargerOffres() async {
    _page = 0;
    plusDOffres.value = true;
    chargement.value = true;
    erreur.value = '';
    final resultat = await _voirLesOffres(page: _page, limite: _limite);
    resultat.fold(
      (msg) => erreur.value = msg,
      (liste) {
        offres.assignAll(liste);
        plusDOffres.value = liste.length == _limite;
        _page++;
      },
    );
    chargement.value = false;
  }

  Future<void> chargerPlus() async {
    if (chargementPlus.value || !plusDOffres.value) return;
    chargementPlus.value = true;
    final resultat = await _voirLesOffres(page: _page, limite: _limite);
    resultat.fold((_) => null, (liste) {
      offres.addAll(liste);
      plusDOffres.value = liste.length == _limite;
      _page++;
    });
    chargementPlus.value = false;
  }

  Future<void> rechercher(String texte) async {
    if (texte.trim().isEmpty) {
      chargerOffres();
      return;
    }
    chargement.value = true;
    erreur.value = '';
    final resultat = await _chercherOffres(texte);
    resultat.fold(
        (msg) => erreur.value = msg, (liste) => offres.assignAll(liste));
    chargement.value = false;
  }

  void changerOnglet(String onglet) {
    if (ongletActif.value == onglet) return;
    ongletActif.value = onglet;
    if (onglet == 'recommandees' && recommandations.isEmpty) {
      chargerRecommandations();
    } else if (onglet != 'recommandees') {
      chargerOffres();
    }
  }

  Future<void> rafraichir() async {
    if (ongletActif.value == 'recommandees') {
      await chargerRecommandations();
    } else {
      await chargerOffres();
    }
  }

  Future<void> chargerStats() async {
    final resultat = await _voirStats();
    resultat.fold((_) => null,
        (stats) => totalOffres.value = stats['total_jobs'] as int? ?? 0);
  }

  List<OffreEmploi> get offresAffichees =>
      ongletActif.value == 'recommandees' && aRecommandations
          ? recommandations
          : offres;
}
