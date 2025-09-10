import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/services/storage_service.dart';

class ClockService extends GetxService {
  late final StorageService _storageService;
  final _clockOpen = true.obs; // saat varsayılan olarak açık
  bool get clockMode => _clockOpen.value; // sadece okunabilir getter

  @override
  void onInit() {
    super.onInit();
    _storageService = Get.find<StorageService>();
    loadClockStatus();
  }

  void loadClockStatus() {
    final savedClockMode = _storageService.getValue<String>(
      StorageKeys.clockCheck,
    );

    if (savedClockMode != null) {
      _clockOpen.value = savedClockMode == 'true';
    } else {
      _clockOpen.value = true;
    }
  }

  Future<void> toggleClock() async {
    _clockOpen.value = !_clockOpen.value;
    await _storageService.setValue<String>(
      StorageKeys.clockCheck,
      _clockOpen.value.toString(),
    );
  }
}
