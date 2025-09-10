import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/core/base_controller.dart';
import 'package:kirtasiyem_sqlite/db/db_erisim.dart';
import 'package:kirtasiyem_sqlite/models/urunler_liste.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_brand.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_category.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/info_row.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_barcode.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_count.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_description.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_price.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/save_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProductController extends BaseController {
  var urunListesi = <Urunler>[].obs;
  var aktifSayfa = 1.obs;
  final barkodTextController = TextEditingController();
  final productCountTextController = TextEditingController();
  final productDescriptionTextController = TextEditingController();
  final productPriceTextController = TextEditingController();
  final productCategoryTextController = TextEditingController();
  final productMarkaTextController = TextEditingController();

  RxMap<String, String> selectedDescription = <String, String>{}.obs;
  RxMap<String, String> selectedBrand = <String, String>{}.obs;

  final searchProduct = "".obs;
  final urunBarkod = "".obs;
  final urunDescription = "".obs;
  final urunAdet = 0.obs;
  final urunFiyat = 0.0.obs;
  final kategori = "".obs;
  final marka = "".obs;
  final formKey = GlobalKey<FormState>();
  var isSearching = false.obs;
  final urunGuncelleme = false.obs;

  Future<void> urunDuzenleDiyalog(Urunler uruns) async {
    urunBarkod.value = uruns.urun_barkod;
    barkodTextController.text = uruns.urun_barkod;
    urunDescription.value = uruns.urun_description;
    productDescriptionTextController.text = uruns.urun_description;
    productCategoryTextController.text = uruns.category;
    productMarkaTextController.text = uruns.marka;
    kategori.value = uruns.category;
    marka.value = uruns.marka;

    urunAdet.value = uruns.urun_adet;
    productCountTextController.text = uruns.urun_adet.toString();

    urunFiyat.value = uruns.urun_fiyat;
    productPriceTextController.text = uruns.urun_fiyat.toString();

    urunGuncelleme.value = true;

    await diyalog(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ProductBarcode(),
                const SizedBox(height: 10),
                ProductBrand(),
                const SizedBox(height: 10),
                ProductCategory(),
                const SizedBox(height: 10),
                const ProductDescription(),
                const SizedBox(height: 10),
                const ProductCount(),
                const SizedBox(height: 10),
                const ProductPrice(),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                SaveButton(urunId: uruns.urun_id!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleSearch() {
    if (isSearching.value) {
      searchProduct.value = "";
    }
    isSearching.value = !isSearching.value;
  }

  Future<bool> silDiyalog({required Urunler item}) async {
    final sonuc = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Silmek İstediğinize Emin Misiniz?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow("Kategori", item.category),
            InfoRow("Ürün Markası", item.marka),
            InfoRow("Urun Açıklaması", item.urun_description),
            InfoRow("Ürün Adedi", item.urun_adet.toString()),
            InfoRow("Ürün Fiyatı", item.urun_fiyat.toString()),
            InfoRow("Ürün Barkod", item.urun_barkod),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(result: false),
                  icon: const Icon(Icons.back_hand, color: Colors.green),
                  label: const Text("İPTAL"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Get.back(result: true),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("SİL"),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return sonuc ?? false;
  }

  MobileScannerController barkodTur = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 500,
    autoZoom: true,
  );

  void setBarkod(String value) {
    urunBarkod.value = value;
    barkodTextController.text = value;
  }

  void sayfaDegistir(int yeniSayfa) {
    aktifSayfa.value = yeniSayfa;
  }

  @override
  void onInit() {
    super.onInit();
    urunleriGetir();
  }

  Future<void> urunleriGetir() async {
    final db = await VeritabaniYardimcisi.veritabaniErisim();
    final result = await db.query('urunlerListe');
    urunListesi.value = result.map((e) => Urunler.fromMap(e)).toList();
  }

  Future<void> urunEkle() async {
    try {
      var db = await VeritabaniYardimcisi.veritabaniErisim();

      var checkBarkode = await db.query(
        "urunlerListe",
        where: "urun_barkod=?",
        whereArgs: [urunBarkod.value],
      );

      if (checkBarkode.isEmpty) {
        var yeniurun = Urunler(
          urun_barkod: urunBarkod.value,
          urun_description: urunDescription.value,
          urun_adet: urunAdet.value,
          urun_fiyat: urunFiyat.value,
          category: kategori.value,
          marka: marka.value,
        );

        await db.insert("urunlerListe", yeniurun.toMap());
        clearForm();
        await urunleriGetir();
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Bir Sorun Oluştu : $e");
    }
  }

  Future<void> alisverisStokGuncelle(int urunIdd, int adet) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.update(
      "urunlerListe",
      {"urun_adet": adet},
      where: "urun_id=?",
      whereArgs: [urunIdd],
    );
    await urunleriGetir();
  }

  Future<void> gecmisStokGuncelle({
    required int urunID,
    required int gecmisAdet,
    required String urunAd,
  }) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    final urun = urunListesi.firstWhereOrNull((e) => e.urun_id == urunID);

    if (urun != null) {
      final yeniAdet = urun.urun_adet + gecmisAdet;

      await db.update(
        "urunlerListe",
        {"urun_adet": yeniAdet},
        where: "urun_id=?",
        whereArgs: [urunID],
      );

      await urunleriGetir();
      showSuccessSnackbar(message: "Stok güncellendi ($urunAd)/(+$gecmisAdet)");
    } else {
      showErrorSnackbar(message: "Ürün Envanterde Bulunamadı");
    }
  }

  Future<void> urunGuncelle(int urunId) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    await db.update(
      "urunlerListe",
      Urunler(
        urun_id: urunId,
        urun_barkod: urunBarkod.value,
        urun_description: urunDescription.value,
        urun_adet: urunAdet.value,
        urun_fiyat: urunFiyat.value,
        category: kategori.value,
        marka: marka.value,
      ).toMap(),
      where: "urun_id=?",
      whereArgs: [urunId],
    );

    await urunleriGetir(); // listeyi yenile
    Get.back(); // diyalogu kapat
    showSuccessSnackbar(message: "Ürün başarıyla güncellendi");
  }

  List<Urunler> get filtreliListe {
    if (searchProduct.value.isEmpty || searchProduct.value == "") {
      return urunListesi;
    } else {
      return urunListesi.where((urun) {
        return urun.urun_description.toLowerCase().contains(
          searchProduct.value.toLowerCase(),
        );
      }).toList();
    }
  }

  List<String> get kategoriler {
    final kategoriSet = urunListesi.map((u) => u.category).toSet();
    final kategoriList = kategoriSet.toList();
    kategoriList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return kategoriList;
  }

  Map<String, List<Urunler>> get groupedProductsByCategory {
    final Map<String, List<Urunler>> grouped = {};
    for (var item in urunListesi) {
      final category = item.category;
      if (!grouped.containsKey(category)) grouped[category] = [];
      grouped[category]!.add(item);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  List<String> get markalar {
    final markaSet = urunListesi.map((u) => u.marka).toSet();
    final markaList = markaSet.toList();
    markaList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return markaList;
  }

  void barkodUrunArama(String value) async {
    final eslesenUrun = urunListesi.firstWhereOrNull(
      (u) => u.urun_barkod == value,
    );

    if (eslesenUrun != null) {
      await barkodTur.stop();
      await Future.delayed(const Duration(milliseconds: 200));
      Get.back(); // kamera sayfasını kapat
      urunDuzenleDiyalog(eslesenUrun);
    } else {
      Get.back();
      showErrorSnackbar(message: "Barkod Bulunamadı");
    }
  }

  Future<void> urunSil({required int urunId}) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("urunlerListe", where: "urun_id=?", whereArgs: [urunId]);
  }

  void clearForm() {
    urunBarkod.value = "";
    urunDescription.value = "";
    marka.value = "";
    urunAdet.value = 0;
    urunFiyat.value = 0.0;
    kategori.value = "-";
    barkodTextController.clear();
    productCountTextController.clear();
    productDescriptionTextController.clear();
    productPriceTextController.clear();
    productCategoryTextController.clear();
    productMarkaTextController.clear();
  }
}
