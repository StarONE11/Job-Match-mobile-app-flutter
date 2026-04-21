import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/datasources/candidat_datasource.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidatDataSource>(() => CandidatDataSource());
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(
        storage: Get.find<StorageService>(),
        candidatDs: Get.find<CandidatDataSource>(),
      ),
    );
  }
}
