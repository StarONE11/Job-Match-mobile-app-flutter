import 'package:get/get.dart';

// ─── CONTROLLER PROFIL ────────────────────────────────────────────────────────
// Gère les données du profil utilisateur.
// Pour l'instant les données sont statiques (pas encore de backend auth).

class ProfilController extends GetxController {
  // Infos utilisateur
  final RxString nom          = 'Joseph Etenda'.obs;
  final RxString metier       = 'Développeur Web'.obs;
  final RxString ville        = 'Lomé, Togo'.obs;
  final RxString email        = 'joseph.etenda@email.com'.obs;
  final RxString telephone    = '+228 70 02 04 70'.obs;

  // CV
  final RxString nomCv        = 'CV_Joe_2026.pdf'.obs;
  final RxString dateCv       = 'Mis à jour il y a 2 jours'.obs;
  final RxBool  cvCharge      = true.obs;

  // Compétences
  final RxList<String> competences = <String>[
    'Flutter', 'Python', 'React', 'FastAPI'
  ].obs;

  // Statistiques
  final RxInt candidatures = 12.obs;
  final RxInt favoris      = 5.obs;
  final RxInt entretiens   = 3.obs;

  // Ajouter une compétence
  void ajouterCompetence(String competence) {
    if (competence.trim().isNotEmpty &&
        !competences.contains(competence.trim())) {
      competences.add(competence.trim());
    }
  }

  // Retirer une compétence
  void retirerCompetence(String competence) {
    competences.remove(competence);
  }

  // Alertes emploi
  final RxBool alertesActives       = true.obs;
  final RxString frequenceAlerte    = 'immediat'.obs;
  final RxList<String> motsCles     = <String>['Flutter', 'Développeur', 'Mobile'].obs;
  final RxString localisationAlerte = 'Lomé, Togo'.obs;
  final RxString typeContratAlerte  = 'tous'.obs;

  // Sauvegarder les modifications du profil
  void sauvegarderProfil({
    required String nouveauNom,
    required String nouveauMetier,
    required String nouvelleVille,
    required String nouvelEmail,
    required String nouveauTelephone,
  }) {
    nom.value       = nouveauNom.trim().isEmpty ? nom.value : nouveauNom.trim();
    metier.value    = nouveauMetier.trim().isEmpty ? metier.value : nouveauMetier.trim();
    ville.value     = nouvelleVille.trim().isEmpty ? ville.value : nouvelleVille.trim();
    email.value     = nouvelEmail.trim().isEmpty ? email.value : nouvelEmail.trim();
    telephone.value = nouveauTelephone.trim().isEmpty ? telephone.value : nouveauTelephone.trim();

    Get.back();
    Get.snackbar(
      'Profil mis à jour',
      'Vos modifications ont été sauvegardées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Sauvegarder les alertes
  void sauvegarderAlertes() {
    Get.back();
    Get.snackbar(
      'Alertes mises à jour',
      alertesActives.value
          ? 'Vous recevrez des alertes emploi'
          : 'Les alertes ont été désactivées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Ajouter un mot-clé d'alerte
  void ajouterMotCle(String motCle) {
    if (motCle.trim().isNotEmpty && !motsCles.contains(motCle.trim())) {
      motsCles.add(motCle.trim());
    }
  }

  // Retirer un mot-clé d'alerte
  void retirerMotCle(String motCle) {
    motsCles.remove(motCle);
  }

  // Déconnexion
  void deconnecter() {
    Get.offAllNamed('/home');
    Get.snackbar(
      'Déconnecté',
      'À bientôt !',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Initiales de l'utilisateur (ex: "Kofi Mensah" → "KM")
  String get initiales {
    final mots = nom.value.trim().split(' ');
    if (mots.length >= 2) return '${mots[0][0]}${mots[1][0]}'.toUpperCase();
    return nom.value.substring(0, 2).toUpperCase();
  }
}
