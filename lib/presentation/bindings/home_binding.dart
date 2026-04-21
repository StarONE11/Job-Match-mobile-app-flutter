import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../data/datasources/offre_datasource.dart';
import '../../data/datasources/candidat_datasource.dart';
import '../../data/repositories/offre_repository_impl.dart';
import '../../domain/usecases/offre_usecases.dart';
import '../controllers/home_controller.dart';
import '../controllers/favoris_controller.dart';

// ─── BINDING DE LA HOME PAGE ──────────────────────────────────────────────────
//
// Le Binding crée tout ce dont la page a besoin, dans le bon ordre.
// GetX l'appelle automatiquement quand on navigue vers la HomePage.
//
// Ordre de création :
//   DataSource → Repository → UseCases → Controller
//
// Tu n'as JAMAIS besoin d'écrire "new HomeController(...)" dans ta page.
// Tu fais juste Get.find<HomeController>() et GetX le retrouve.

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 1. La source de données (parle à l'API)
    Get.lazyPut<OffreDataSource>(
      () => OffreDataSource(),
    );

    // 2. Le repository (fait le lien data ↔ domain)
    Get.lazyPut<OffreRepositoryImpl>(
      () => OffreRepositoryImpl(Get.find<OffreDataSource>()),
    );

    // 3. Les UseCases (une action = un UseCase)
    Get.lazyPut(() => VoirLesOffres(Get.find<OffreRepositoryImpl>()));
    Get.lazyPut(() => ChercherOffres(Get.find<OffreRepositoryImpl>()));
    Get.lazyPut(() => VoirStats(Get.find<OffreRepositoryImpl>()));

    // 4a. FavorisController (utilisé aussi par la HomePage pour les favoris)
    Get.lazyPut<FavorisController>(() => FavorisController(), fenix: true);

    // 4b. CandidatDataSource (pour le matching CV)
    Get.lazyPut<CandidatDataSource>(() => CandidatDataSource(), fenix: true);

    // 4. Le Controller (cerveau de la page)
    Get.lazyPut<HomeController>(
      () => HomeController(
        voirLesOffres: Get.find<VoirLesOffres>(),
        chercherOffres: Get.find<ChercherOffres>(),
        voirStats: Get.find<VoirStats>(),
        storage: Get.find<StorageService>(),
        candidatDs: Get.find<CandidatDataSource>(),
      ),
    );
  }
}
