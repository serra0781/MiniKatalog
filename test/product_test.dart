import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  test('Product fromJson / toJson', () {
    final json = {
      'id': 1,
      'name': 'Seramik Kupa',
      'category': 'Ev',
      'price': 249.9,
      'image': 'assets/images/kupa.png',
      'rating': 4.8,
      'description': 'Pastel kupa',
    };

    final product = Product.fromJson(json);

    expect(product.name, 'Seramik Kupa');
    expect(product.price, 249.9);
    expect(product.formattedPrice, '249,90 ₺');
    expect(product.toJson(), json);
  });
}
