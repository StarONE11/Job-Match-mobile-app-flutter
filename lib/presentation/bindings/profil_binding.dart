import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../data/datasources/candidat_datasource.dart';
import '../controllers/profil_controller.dart';

class ProfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidatDataSource>(() => CandidatDataSource(), fenix: true);
    Get.lazyPut<ProfilController>(
      () => ProfilController(
        storage: Get.find<StorageService>(),
        candidatDs: Get.find<CandidatDataSource>(),
      ),
      fenix: true,
    );
  }
}
