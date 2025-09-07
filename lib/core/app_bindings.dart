import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/dashboard_controller.dart';
import 'package:kirtasiyem_sqlite/modules/history/history_controller.dart';
import 'package:kirtasiyem_sqlite/modules/home/home_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/services/storage_service.dart';
import 'package:kirtasiyem_sqlite/services/theme_service.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StorageService>(() async {
      final service = StorageService();
      await service.init();
      return service;
    }, permanent: true);

    Get.put(ThemeService(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(HistoryController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
  }
}
