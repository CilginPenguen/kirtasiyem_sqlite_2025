import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:kirtasiyem_sqlite/modules/products/product_controller.dart';
import 'package:kirtasiyem_sqlite/utils/product_price_formatter.dart';

class ProductPrice extends GetView<ProductController> {
  const ProductPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.productPriceTextController,
      decoration: InputDecoration(
        labelText: "Ürün Fiyatı",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money_outlined),
      ),
      inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        controller.urunFiyat.value =
            double.tryParse(value) ?? controller.urunFiyat.value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Miktarı Giriniz";
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return "Geçersiz Veri";
        }
        return null;
      },
    );
  }
}
