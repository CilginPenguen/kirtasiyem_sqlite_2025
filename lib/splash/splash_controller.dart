import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/services/storage_service.dart';
import 'package:kirtasiyem_sqlite/routes/app_pages.dart';

class SplashController extends BaseController {
  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    // AppBindings ile asenkron servisleri beklet
    while (!Get.isRegistered<StorageService>()) {
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Servisler hazır → yönlendir
    Get.offAllNamed(AppRoutes.home);
  }
}
