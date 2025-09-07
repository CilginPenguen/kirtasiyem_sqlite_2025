import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/barcode_scanner.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/product_actions.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/product_card.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/product_title.dart';
import 'package:kirtasiyem_sqlite/themes/app_colors.dart';

class Products extends GetView<ProductController> {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ProductTitle(shop: false),
        actions: [ProductActions()],
      ),
      body: controller.urunListesi.isEmpty
          ? const Center(child: Text("Ürün bulunamadı."))
          : Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.isSearching.value
                    ? controller.filtreliListe.length
                    : controller.urunListesi.length,
                itemBuilder: (context, index) {
                  final urun = controller.isSearching.value
                      ? controller.filtreliListe[index]
                      : controller.urunListesi[index];
                  return Dismissible(
                    key: ValueKey(urun.urun_id ?? UniqueKey()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await controller.silDiyalog(item: urun);
                    },
                    onDismissed: (direction) async {
                      await controller.urunSil(urunId: urun.urun_id!);
                      controller.urunListesi.removeAt(index);
                    },
                    child: GestureDetector(
                      onTap: () {
                        controller.urunDuzenleDiyalog(urun);
                      },
                      child: ProductCard(urun: urun),
                    ),
                  );
                },
              );
            }),
      bottomNavigationBar: Visibility(
        visible: Get.isRegistered<BasketController>(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.darkTiffanyBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(125),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => Get.to(BarcodeScanner(mod: 3)),
                icon: const Icon(Icons.barcode_reader, size: 20),
                label: const Text("Tara ve Ekle"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              SizedBox(width: 5),
              OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.done_all, size: 20),
                label: const Text("Sepeti Tamamla"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
