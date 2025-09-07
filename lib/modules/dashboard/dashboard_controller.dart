import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/modules/history/history_controller.dart';

class DashboardController extends BaseController {
  RxBool isExpanded = false.obs;
  final aylikGelir = 0.0.obs;
  final aylikGider = 0.0.obs;
  var l = Get.find<HistoryController>();

  List<String> sayiTipi = [
    " ",
    " ",
    "III",
    " ",
    " ",
    "VI",
    " ",
    " ",
    "IX",
    " ",
    " ",
    "XII",
  ];

  @override
  void onInit() async {
    await l.gecmisGetir();
    l.gecmisList;
    super.onInit();
  }
}
