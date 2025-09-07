import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';

class ProductActions extends GetView<ProductController> {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Visibility(
            visible: Get.isRegistered<BasketController>(),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.barcode_reader),
            ),
          ),
          IconButton(
            icon: Icon(
              controller.isSearching.value ? Icons.close : Icons.search,
              color: Colors.red,
              size: 35,
            ),
            onPressed: controller.toggleSearch,
          ),
        ],
      ),
    );
  }
}
