import 'package:flutter/material.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:kirtasiyem_sqlite/modules/screensaver/screensaver_controller.dart';

class ScreensaverPage extends GetView<ScreensaverController> {
  const ScreensaverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: AnalogClock()),
      ),
    );
  }
}
