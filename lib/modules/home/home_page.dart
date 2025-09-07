import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/home/home_controller.dart';
import 'package:kirtasiyem_sqlite/modules/home/widgets/BotNavBar.dart';
import 'package:kirtasiyem_sqlite/routes/app_pages.dart';
import 'package:kirtasiyem_sqlite/themes/app_colors.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.buildPage(controller.currentIndex.value)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.basket),
        backgroundColor: AppColors.darkHotPink,
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BotNavBar(),
    );
  }
}
