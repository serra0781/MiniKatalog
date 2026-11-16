import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../theme.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Cart.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.blush),
                  SizedBox(height: 12),
                  Text('Sepetin şu an boş', style: TextStyle(color: AppColors.mauve)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final p = cart.products[index];
                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.blush),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(p.image, width: 52, height: 52, fit: BoxFit.cover),
                        ),
                        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          p.formattedPrice,
                          style: const TextStyle(color: AppColors.roseDark),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => cart.decrease(p),
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.mauve),
                            ),
                            Text('${cart.quantityOf(p)}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            IconButton(
                              onPressed: () => cart.add(p),
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.rose),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildTotal(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotal(BuildContext context, Cart cart) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Toplam (${cart.totalCount} ürün)',
                    style: const TextStyle(color: AppColors.mauve)),
                const Spacer(),
                Text(
                  '${cart.totalPrice.toStringAsFixed(2).replaceAll('.', ',')} ₺',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // ödeme yok, sadece simülasyon
                  cart.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Siparişin alındı (simülasyon) ♡'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.plum,
                    ),
                  );
                },
                child: const Text('Siparişi Tamamla'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
