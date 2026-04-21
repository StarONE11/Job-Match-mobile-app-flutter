import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/offre_emploi_model.dart';
import '../../domain/entities/offre_emploi.dart';

class FavorisController extends GetxController {
  static const _kFavoris = 'favoris_list';

  final RxList<OffreEmploi> favoris = <OffreEmploi>[].obs;

  @override
  void onInit() {
    super.onInit();
    _charger();
  }

  Future<void> _charger() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_kFavoris) ?? [];
    final liste = raw
        .map((s) =>
            OffreEmploiModel.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
    favoris.assignAll(liste);
  }

  Future<void> _sauvegarder() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = favoris
        .map((o) => jsonEncode(OffreEmploiModel(
              id: o.id,
              titre: o.titre,
              entreprise: o.entreprise,
              localisation: o.localisation,
              source: o.source,
              description: o.description,
              typeContrat: o.typeContrat,
              salaireRange: o.salaireRange,
              niveauExperience: o.niveauExperience,
              competences: o.competences,
              lienOffre: o.lienOffre,
              datePublication: o.datePublication,
              descriptionComplete: o.descriptionComplete,
              scoreMatch: o.scoreMatch,
            ).toJson()))
        .toList();
    await prefs.setStringList(_kFavoris, raw);
  }

  void toggleFavori(OffreEmploi offre) {
    final existe = favoris.any((f) => f.id == offre.id);
    if (existe) {
      favoris.removeWhere((f) => f.id == offre.id);
      Get.snackbar('Retiré des favoris', offre.titre,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    } else {
      favoris.add(offre);
      Get.snackbar('Ajouté aux favoris', offre.titre,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2));
    }
    _sauvegarder();
  }

  bool estFavori(int id) => favoris.any((f) => f.id == id);
  int get total => favoris.length;
}
