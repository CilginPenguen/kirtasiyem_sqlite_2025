import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/db/db_erisim.dart';
import 'package:kirtasiyem_sqlite/models/gecmis_siparis.dart';
import 'package:kirtasiyem_sqlite/models/sepet_liste.dart';
import 'package:kirtasiyem_sqlite/modules/history/history_controller.dart';
import 'package:kirtasiyem_sqlite/modules/home/home_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';

class BasketController extends BaseController {
  var basketList = <Sepet>[].obs;
  DateTime anlikTarih = DateTime.now();
  DateFormat tarihFormati = DateFormat("yyyy-MM-dd");

  bool sepetKontrol({required int id}) {
    return basketList.any((item) => item.urun_id == id);
  }

  double getAspectRatio(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 600) {
      return 0.85; // Küçük ekran: kart daha uzun
    } else if (screenHeight < 800) {
      return 1.1; // Orta ekran
    } else {
      return 1.35; // Büyük ekran
    }
  }

  Future<bool> sepetiOnayla() async {
    try {
      var db = await VeritabaniYardimcisi.veritabaniErisim();
      var gecmisYenile = Get.find<HistoryController>();
      var proCont = Get.find<ProductController>();
      var homCont = Get.find<HomeController>();

      for (var i in basketList) {
        double salary = i.urun_fiyat * i.sepet_birim;
        await proCont.alisverisStokGuncelle(
          i.urun_id!,
          i.urun_adet - i.sepet_birim,
        );
        var gecmis = Gecmis(
          urun_id: i.urun_id,
          urun_description: i.urun_description,
          urun_adet: i.urun_adet,
          urun_fiyat: i.urun_fiyat,
          category: i.category,
          sepet_birim: i.sepet_birim,
          toplam_tutar: salary,
          tarih: tarihFormati.format(anlikTarih),
          urun_barkod: i.urun_barkod,
          marka: i.marka,
        );
        await db.insert("gecmisSiparis", gecmis.toMap());
      }
      await gecmisYenile.gecmisGetir();
      gecmisYenile.dailyIncome;
      gecmisYenile.monthlyIncome;
      basketList.clear();
      homCont.changePage(0);
      return true;
    } on Exception catch (e) {
      print(e);
      showErrorSnackbar(message: "Bir hata oluştu: $e");
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    final home = Get.find<HomeController>();
    if (home.backupBasketList.isNotEmpty) {
      basketList.assignAll(home.backupBasketList);
    }
  }

  Future<void> saveBasket() async {
    final l = Get.find<HomeController>();
    await alertDiyalog(
      title: "Sepet Kaydedilsin Mi?",
      widgets: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              l.backupBasketList.value = basketList;
              Get.back(closeOverlays: true);
            },
            label: Text("Evet"),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Get.back(closeOverlays: true);
              if (l.backupBasketList.isNotEmpty) {
                l.backupBasketList.clear();
              }
            },
            label: Text("Hayır"),
          ),
        ],
      ),
    );
  }
}
