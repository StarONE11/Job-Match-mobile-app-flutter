import 'package:get/get.dart';
import '../controllers/favoris_controller.dart';

class FavorisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavorisController>(() => FavorisController());
  }
}
