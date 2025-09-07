import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_controller.dart';

class BasketBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(BasketController());
  }
}
