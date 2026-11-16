import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_button.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/detail';

  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ana sayfadan gönderilen ürünü route arguments ile al
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        actions: const [CartButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'product-${product.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.category,
                  style: const TextStyle(fontSize: 12, color: AppColors.roseDark),
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, color: Color(0xFFF2B84B), size: 20),
              const SizedBox(width: 2),
              Text(product.rating.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            product.formattedPrice,
            style: const TextStyle(
              fontSize: 22,
              color: AppColors.roseDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(fontSize: 15, height: 1.5, color: AppColors.mauve),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ListenableBuilder(
            listenable: Cart.instance,
            builder: (context, _) {
              final qty = Cart.instance.quantityOf(product);
              return ElevatedButton.icon(
                onPressed: () {
                  Cart.instance.add(product);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${product.name} sepete eklendi'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.plum,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(qty == 0 ? 'Sepete Ekle' : 'Sepete Ekle ($qty)'),
              );
            },
          ),
        ),
      ),
    );
  }
}
