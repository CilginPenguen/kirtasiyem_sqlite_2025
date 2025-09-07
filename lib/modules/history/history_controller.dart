import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/db/db_erisim.dart';
import 'package:kirtasiyem_sqlite/models/gecmis_siparis.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';

class HistoryController extends BaseController {
  final gecmisList = <Gecmis>[].obs;

  /// Geçmiş verilerini getir
  Future<void> gecmisGetir() async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    final result = await db.query("gecmisSiparis");
    gecmisList.value = result.map((e) => Gecmis.fromMap(e)).toList();
  }

  /// Günlük toplam
  double get dailyIncome {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return gecmisList
        .where((e) => e.tarih == today)
        .fold(0.0, (sum, e) => sum + e.toplam_tutar);
  }

  /// Aylık toplam
  double get monthlyIncome {
    final now = DateTime.now();
    final currentMonth = DateFormat('yyyy-MM').format(now);
    return gecmisList
        .where((e) => e.tarih.startsWith(currentMonth))
        .fold(0.0, (sum, e) => sum + e.toplam_tutar);
  }

  /// Sadece bugünün verisi
  List<Gecmis> get todaysData {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return gecmisList.where((item) => item.tarih == today).toList();
  }

  /// Tarih bazlı gruplama
  Map<String, List<Gecmis>> get groupedSalesByDate {
    final Map<String, List<Gecmis>> grouped = {};

    for (var item in gecmisList) {
      final date = item.tarih; // zaten "yyyy-MM-dd" string geliyor
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }

    // Tarihleri büyükten küçüğe sırala (yeni tarih en üstte)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  /// 🔹 Tek kaydı sil
  Future<void> deleteSale(Gecmis item) async {
    await alertDiyalog(
      title: "Onay",
      widgets: Row(
        children: [
          TextButton(
            onPressed: () => Get.back(), // vazgeç
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              var c = Get.find<ProductController>();
              c.gecmisStokGuncelle(
                urunID: item.urun_id!,
                gecmisAdet: item.sepet_birim,
                urunAd: item.urun_description,
              );
              Get.back();
              final db = await VeritabaniYardimcisi.veritabaniErisim();
              await db.delete(
                "gecmisSiparis",
                where: "gecmis_id = ?",
                whereArgs: [item.gecmis_id],
              );

              gecmisList.remove(item);
              showSuccessSnackbar(message: "Kayıt başarıyla silindi.");
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 🔹 Tarihe ait tüm kayıtları sil
  Future<void> deleteSalesByDate(String date) async {
    await alertDiyalog(
      title: "Onay",
      widgets: Row(
        children: [
          TextButton(onPressed: () => Get.back(), child: const Text("İptal")),
          TextButton(
            onPressed: () async {
              final db = await VeritabaniYardimcisi.veritabaniErisim();
              await db.delete(
                "gecmisSiparis",
                where: "tarih = ?",
                whereArgs: [date],
              );
              gecmisList.removeWhere((e) => e.tarih == date);
              Get.back();
              showSuccessSnackbar(
                message: "$date tarihli tüm kayıtlar silindi.",
              );
            },
            child: const Text(
              "Hepsini Sil",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
