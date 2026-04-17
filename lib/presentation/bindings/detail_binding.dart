import 'package:get/get.dart';
import '../../data/datasources/offre_datasource.dart';
import '../../data/repositories/offre_repository_impl.dart';
import '../../domain/usecases/offre_usecases.dart';
import '../controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OffreDataSource>(() => OffreDataSource());
    Get.lazyPut<OffreRepositoryImpl>(
      () => OffreRepositoryImpl(Get.find<OffreDataSource>()),
    );
    Get.lazyPut(() => VoirDetailOffre(Get.find<OffreRepositoryImpl>()));
    Get.lazyPut<DetailController>(
      () => DetailController(voirDetail: Get.find<VoirDetailOffre>()),
    );
  }
}
