import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/models/sepet_liste.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/dashboard_page.dart';
import 'package:kirtasiyem_sqlite/modules/history/history_page.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/product_floatAction.dart';
import 'package:kirtasiyem_sqlite/modules/settings/settings_page.dart';

class HomeController extends BaseController {
  final currentIndex = 0.obs;
  final backupBasketList = <Sepet>[].obs;
  changePage(int index) {
    currentIndex.value = index;
  }

  void diyalogYolla() async {
    alertDiyalog(
      title: "Deneme",
      widgets: Row(
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Evet")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text("Hayır"),
          ),
        ],
      ),
    );
  }

  Widget buildPage(int index) {
    switch (index) {
      case 0:
        return DashboardPage();
      case 1:
        return ProductFloatingAction();
      case 2:
        return HistoryPage();
      case 3:
        return SettingsPage();
      default:
        return DashboardPage();
    }
  }
}
