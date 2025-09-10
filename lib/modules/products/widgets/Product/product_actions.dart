import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/basket/basket_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/barcode_scanner.dart';

class ProductActions extends GetView<ProductController> {
  const ProductActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: Get.isRegistered<BasketController>(),
          child: IconButton(
            onPressed: () => Get.to(BarcodeScanner(mod: 3)),
            icon: const Icon(Icons.barcode_reader),
          ),
        ),
      ],
    );
  }
}
