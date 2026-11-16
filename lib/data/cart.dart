import 'package:flutter/foundation.dart';

import '../models/product.dart';

// Basit sepet simülasyonu. Ekstra paket kullanmadan ChangeNotifier ile
// sepet değişince ilgili widget'lar yeniden çiziliyor.
class Cart extends ChangeNotifier {
  Cart._();
  static final Cart instance = Cart._();

  // ürün id -> adet
  final Map<int, int> _quantities = {};
  final Map<int, Product> _products = {};

  List<Product> get products => _products.values.toList();

  int quantityOf(Product p) => _quantities[p.id] ?? 0;

  int get totalCount => _quantities.values.fold(0, (sum, q) => sum + q);

  double get totalPrice {
    double total = 0;
    _products.forEach((id, p) => total += p.price * _quantities[id]!);
    return total;
  }

  void add(Product p) {
    _products[p.id] = p;
    _quantities[p.id] = quantityOf(p) + 1;
    notifyListeners();
  }

  void decrease(Product p) {
    final q = quantityOf(p);
    if (q <= 1) {
      remove(p);
    } else {
      _quantities[p.id] = q - 1;
      notifyListeners();
    }
  }

  void remove(Product p) {
    _products.remove(p.id);
    _quantities.remove(p.id);
    notifyListeners();
  }

  void clear() {
    _products.clear();
    _quantities.clear();
    notifyListeners();
  }
}
