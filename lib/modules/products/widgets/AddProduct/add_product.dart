import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_brand.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_category.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/Product/barcode_scanner.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_barcode.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_count.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_description.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/product_price.dart';
import 'package:kirtasiyem_sqlite/modules/products/widgets/AddProduct/save_button.dart';

class AddProduct extends GetView<ProductController> {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ürün Ekle")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: ProductBarcode()),
                  IconButton(
                    onPressed: () {
                      Get.to(() => BarcodeScanner(mod: 2));
                    },
                    icon: Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
              ProductBrand(),
              SizedBox(height: 8),
              ProductCategory(),
              SizedBox(height: 8),
              ProductDescription(),
              SizedBox(height: 8),
              ProductPrice(),
              SizedBox(height: 8),
              ProductCount(),
              SizedBox(height: 8),
              SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
