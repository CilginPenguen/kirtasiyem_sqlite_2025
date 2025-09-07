import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/splash/splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
