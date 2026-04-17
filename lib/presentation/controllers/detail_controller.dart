import 'package:get/get.dart';
import '../../domain/entities/offre_emploi.dart';
import '../../domain/usecases/offre_usecases.dart';

// ─── CONTROLLER DETAIL ────────────────────────────────────────────────────────
// Reçoit l'ID de l'offre via Get.arguments et charge les détails depuis l'API.

class DetailController extends GetxController {
  final VoirDetailOffre _voirDetail;

  DetailController({required VoirDetailOffre voirDetail})
      : _voirDetail = voirDetail;

  final Rx<OffreEmploi?> offre   = Rx<OffreEmploi?>(null);
  final RxBool chargement        = false.obs;
  final RxString erreur          = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int?;
    if (id != null) chargerOffre(id);
  }

  Future<void> chargerOffre(int id) async {
    chargement.value = true;
    erreur.value = '';

    final resultat = await _voirDetail(id);
    resultat.fold(
      (msg) => erreur.value = msg,
      (data) => offre.value = data,
    );

    chargement.value = false;
  }
}
