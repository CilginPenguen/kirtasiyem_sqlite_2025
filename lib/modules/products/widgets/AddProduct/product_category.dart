import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';

class ProductCategory extends GetView<ProductController> {
  final toggle = false.obs;

  ProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            if (toggle.value) {
              // Dropdown
              final items =
                  controller.kategoriler
                      .where((e) => e.isNotEmpty)
                      .toSet()
                      .toList()
                    ..sort(
                      (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                    );

              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                hint: const Text("Kategori seç"),
                value: items.contains(controller.kategori.value)
                    ? controller.kategori.value
                    : null,
                items: items
                    .map(
                      (kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  controller.kategori.value = value!;
                },
              );
            } else {
              // TextField
              return TextFormField(
                controller: controller.productCategoryTextController,
                decoration: InputDecoration(
                  labelText: "Kategori Giriniz",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                onChanged: (value) {
                  controller.kategori.value = value;
                },
              );
            }
          }),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Kayıtlı Mı?"),
            Obx(
              () => Switch(
                value: toggle.value,
                onChanged: (value) => toggle.value = value,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
