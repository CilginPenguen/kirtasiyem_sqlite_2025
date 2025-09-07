import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/themes/app_colors.dart';

class BaseController extends GetxController {
  Future<void> alertDiyalog({
    required String title,
    required Widget widgets,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        actions: [widgets],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        elevation: 10,
      ),
      barrierDismissible: true,
    );
  }

  Future<void> diyalog(Widget widgets) async {
    Get.dialog(Dialog(child: widgets), barrierDismissible: false);
  }

  void showErrorSnackbar({
    required String message,
    String title = 'Hata',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.isDarkMode
          ? AppColors.darkExpense
          : AppColors.expense,
      colorText: Get.isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      overlayBlur: 0.5,
      overlayColor: Colors.black12,
    );
  }

  void showSuccessSnackbar({
    required String message,
    String title = 'Başarılı',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.isDarkMode ? AppColors.darkIncome : AppColors.income,
      colorText: Get.isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      overlayBlur: 0.5,
      overlayColor: Colors.black12,
    );
  }
}
