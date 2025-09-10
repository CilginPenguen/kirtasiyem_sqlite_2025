import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/dashboard_controller.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/widgets/analog_saat.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/widgets/daily_sales.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/widgets/main_screen.dart';
import 'package:kirtasiyem_sqlite/modules/dashboard/widgets/summary_card.dart';
import 'package:kirtasiyem_sqlite/modules/history/history_controller.dart';
import 'package:kirtasiyem_sqlite/services/clock_service.dart';
import 'package:kirtasiyem_sqlite/themes/app_colors.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();
    final ClockService clockService = Get.find<ClockService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              exit(0);
            },
            icon: Icon(Icons.power_settings_new_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: SummaryCard(
                    title: "Aylık Gelir",
                    amount: historyController.monthlyIncome,
                    icon: Icons.calendar_month,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkIncome
                        : AppColors.income,
                    gradientColors:
                        Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkIncomeGradient
                        : AppColors.incomeGradient,
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: SummaryCard(
                    title: "Günlük Gelir",
                    amount: historyController.dailyIncome,
                    icon: Icons.calendar_today,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkIncome
                        : AppColors.income,
                    gradientColors:
                        Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkIncomeGradient
                        : AppColors.incomeGradient,
                  ),
                ),
              ],
            ),
            Row(
              children: [Flexible(fit: FlexFit.loose, child: DailySales())],
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Obx(
                () => Center(
                  child: IntrinsicWidth(
                    child: clockService.clockMode ? AnalogSaat() : MainScreen(),
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: clockService.clockMode,
                child: OutlinedButton(
                  onPressed: () => clockService.toggleClock(),
                  child: Text("Saati Kapat"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
