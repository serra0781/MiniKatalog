import 'package:flutter/material.dart';

import '../data/cart.dart';
import '../pages/cart_page.dart';
import '../theme.dart';

// AppBar'daki sepet ikonu ve üzerindeki adet rozeti
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Cart.instance,
      builder: (context, _) {
        final count = Cart.instance.totalCount;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () => Navigator.pushNamed(context, CartPage.routeName),
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              backgroundColor: AppColors.roseDark,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        );
      },
    );
  }
}
