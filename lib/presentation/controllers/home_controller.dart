import 'package:get/get.dart';
import '../../domain/entities/offre_emploi.dart';
import '../../domain/usecases/offre_usecases.dart';

// ─── CONTROLLER DE LA PAGE ACCUEIL ───────────────────────────────────────────
//
// C'est le "cerveau" de la HomePage.
// Il ne sait pas comment les données sont récupérées (API, cache, etc.)
// Il sait juste : appeler les UseCases et mettre à jour les variables .obs
//
// Les variables .obs sont "vivantes" :
// quand elles changent → les Obx() dans la page se mettent à jour tout seuls

class HomeController extends GetxController {
  // ── UseCases injectés ─────────────────────────────────────────────────────
  final VoirLesOffres   _voirLesOffres;
  final ChercherOffres  _chercherOffres;
  final VoirStats       _voirStats;

  HomeController({
    required VoirLesOffres voirLesOffres,
    required ChercherOffres chercherOffres,
    required VoirStats voirStats,
  })  : _voirLesOffres  = voirLesOffres,
        _chercherOffres = chercherOffres,
        _voirStats      = voirStats;

  // ── Variables réactives (.obs) ────────────────────────────────────────────
  // Quand tu changes .value → l'écran se met à jour automatiquement

  final RxList<OffreEmploi> offres        = <OffreEmploi>[].obs;
  final RxBool              chargement    = false.obs;
  final RxBool              chargementPlus = false.obs;
  final RxString            erreur        = ''.obs;
  final RxString            ongletActif   = 'recommandees'.obs;
  final RxInt               totalOffres   = 0.obs;
  final RxBool              plusDOffres   = true.obs;

  // Pagination
  int _page = 0;
  static const int _limite = 20;

  // ── Cycle de vie GetX ─────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Chargement automatique au démarrage
    chargerOffres();
    chargerStats();
  }

  // ── ACTIONS ───────────────────────────────────────────────────────────────

  // Charge les offres (premier chargement)
  Future<void> chargerOffres() async {
    _page = 0;
    plusDOffres.value = true;
    chargement.value = true;
    erreur.value = '';

    final resultat = await _voirLesOffres(page: _page, limite: _limite);

    // .fold : si Left (erreur) → affiche l'erreur
    //         si Right (données) → met à jour la liste
    resultat.fold(
      (msg)   => erreur.value = msg,
      (liste) {
        offres.assignAll(liste);
        plusDOffres.value = liste.length == _limite;
        _page++;
      },
    );

    chargement.value = false;
  }

  // Charge les offres suivantes (scroll infini)
  Future<void> chargerPlus() async {
    if (chargementPlus.value || !plusDOffres.value) return;

    chargementPlus.value = true;

    final resultat = await _voirLesOffres(page: _page, limite: _limite);

    resultat.fold(
      (_)     => null, // silence sur l'erreur de pagination
      (liste) {
        offres.addAll(liste);
        plusDOffres.value = liste.length == _limite;
        _page++;
      },
    );

    chargementPlus.value = false;
  }

  // Recherche une offre par texte
  Future<void> rechercher(String texte) async {
    if (texte.trim().isEmpty) {
      chargerOffres();
      return;
    }

    chargement.value = true;
    erreur.value = '';

    final resultat = await _chercherOffres(texte);

    resultat.fold(
      (msg)   => erreur.value = msg,
      (liste) => offres.assignAll(liste),
    );

    chargement.value = false;
  }

  // Change l'onglet (Recommandées / Récentes)
  void changerOnglet(String onglet) {
    if (ongletActif.value == onglet) return;
    ongletActif.value = onglet;
    chargerOffres();
  }

  // Rafraîchit tout (pull to refresh)
  Future<void> rafraichir() => chargerOffres();

  // Charge les stats du dashboard
  Future<void> chargerStats() async {
    final resultat = await _voirStats();
    resultat.fold(
      (_)     => null,
      (stats) => totalOffres.value = stats['total_jobs'] as int? ?? 0,
    );
  }
}
