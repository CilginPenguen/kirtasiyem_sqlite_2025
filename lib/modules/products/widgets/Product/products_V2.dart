import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/product_actions.dart';
import 'product_card.dart';

class ProductByCategoryPage extends GetView<ProductController> {
  const ProductByCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Ürünler"), actions: [ProductActions()]),
      body: Obx(() {
        final groupedData = controller.groupedProductsByCategory;
        if (groupedData.isEmpty) {
          return const Center(child: Text("Henüz ürün yok."));
        }

        return ListView.builder(
          itemCount: groupedData.length,
          itemBuilder: (context, index) {
            final category = groupedData.keys.elementAt(index);
            final items = groupedData[category]!;

            final descList =
                items.map((e) => e.urun_description).toSet().toList()
                  ..sort((a, b) => a.compareTo(b));
            final brandList = items.map((e) => e.marka).toSet().toList()
              ..sort((a, b) => a.compareTo(b));

            final descriptionOptions = ['Hepsi', ...descList];
            final brandOptions = ['Hepsi', ...brandList];

            return Obx(() {
              final selectedDesc =
                  controller.selectedDescription[category] ?? 'Hepsi';
              final selectedBrand =
                  controller.selectedBrand[category] ?? 'Hepsi';

              final safeSelectedDesc = descriptionOptions.contains(selectedDesc)
                  ? selectedDesc
                  : 'Hepsi';
              final safeSelectedBrand = brandOptions.contains(selectedBrand)
                  ? selectedBrand
                  : 'Hepsi';

              final filteredItems = items.where((item) {
                final descOk =
                    safeSelectedDesc == 'Hepsi' ||
                    item.urun_description == safeSelectedDesc;
                final brandOk =
                    safeSelectedBrand == 'Hepsi' ||
                    item.marka == safeSelectedBrand;
                return descOk && brandOk;
              }).toList();

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Column(children: [
                              
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              DropdownButton2<String>(
                                isExpanded: true,
                                value: safeSelectedBrand,
                                items: brandOptions
                                    .map(
                                      (b) => DropdownMenuItem(
                                        value: b,
                                        child: Text(
                                          b,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  controller.selectedBrand[category] = value;
                                },
                                buttonStyleData: ButtonStyleData(
                                  width: screenWidth * 0.3,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  width: screenWidth * 0.5,
                                ),
                              ),
                              const Text(
                                "Marka Filtresi",
                                style: TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Column(
                            children: [
                              DropdownButton2<String>(
                                isExpanded: true,
                                value: safeSelectedDesc,
                                items: descriptionOptions
                                    .map(
                                      (d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(
                                          d,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  controller.selectedDescription[category] =
                                      value;
                                },
                                buttonStyleData: ButtonStyleData(
                                  width: screenWidth * 0.3,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  width: screenWidth * 0.5,
                                ),
                              ),
                              const Text(
                                "Açıklama Filtresi",
                                style: TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  children: filteredItems.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              "Bu kategoride filtreye uyan ürün yok.",
                            ),
                          ),
                        ]
                      : filteredItems
                            .map(
                              (item) => Dismissible(
                                key: ValueKey(item.urun_id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  return await controller.silDiyalog(
                                    item: item,
                                  );
                                },
                                onDismissed: (direction) async {
                                  await controller.urunSil(
                                    urunId: item.urun_id!,
                                  );
                                  controller.urunListesi.removeWhere(
                                    (e) => e.urun_id == item.urun_id,
                                  );
                                  Get.snackbar(
                                    "Silindi",
                                    "${item.urun_description} başarıyla silindi",
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: GestureDetector(
                                    child: ProductCard(urun: item),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                ),
              );
            });
          },
        );
      }),
    );
  }
}
