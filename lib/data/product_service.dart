import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

// Ürünleri assets klasöründeki JSON dosyasından okur (API simülasyonu)
class ProductService {
  static Future<List<Product>> loadProducts() async {
    final String raw = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> list = jsonDecode(raw);
    return list.map((item) => Product.fromJson(item)).toList();
  }
}
