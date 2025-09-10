import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx, Get;
import 'package:get/get_instance/get_instance.dart';
import 'package:kirtasiyem_sqlite/services/clock_service.dart';
import 'package:kirtasiyem_sqlite/services/theme_service.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final ThemeService themeService = Get.find<ThemeService>();
  final ClockService clockService = Get.find<ClockService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar")),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Tema'),
              trailing: Obx(
                () => Switch(
                  value: themeService.isDarkMode,
                  onChanged: (value) => themeService.toogleTheme(),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.lock_clock),
              title: Text('Saati Göster'),
              trailing: Obx(
                () => Switch(
                  value: clockService.clockMode,
                  onChanged: (value) => clockService.toggleClock(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
