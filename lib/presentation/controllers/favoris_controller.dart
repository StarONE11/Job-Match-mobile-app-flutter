import 'package:get/get.dart';
import '../../domain/entities/offre_emploi.dart';

// ─── CONTROLLER FAVORIS ───────────────────────────────────────────────────────
// Gère la liste des offres sauvegardées localement.
// Pas besoin d'API : les favoris sont stockés en mémoire (pour l'instant).

class FavorisController extends GetxController {
  // Liste réactive des offres favorites
  final RxList<OffreEmploi> favoris = <OffreEmploi>[].obs;

  // Ajoute ou retire une offre des favoris
  void toggleFavori(OffreEmploi offre) {
    final existe = favoris.any((f) => f.id == offre.id);
    if (existe) {
      favoris.removeWhere((f) => f.id == offre.id);
      Get.snackbar(
        'Retiré des favoris',
        offre.titre,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      favoris.add(offre);
      Get.snackbar(
        'Ajouté aux favoris',
        offre.titre,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Vérifie si une offre est dans les favoris
  bool estFavori(int id) => favoris.any((f) => f.id == id);

  // Nombre de favoris
  int get total => favoris.length;
}
