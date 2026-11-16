import 'package:flutter/material.dart';

import '../data/product_service.dart';
import '../models/product.dart';
import '../theme.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _products = [];
  bool _loading = true;
  String _search = '';
  String _category = 'Tümü';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await ProductService.loadProducts();
    setState(() {
      _products = products;
      _loading = false;
    });
  }

  List<String> get _categories => ['Tümü', ..._products.map((p) => p.category).toSet()];

  // arama + kategori filtresi
  List<Product> get _filtered {
    return _products.where((p) {
      final matchesCategory = _category == 'Tümü' || p.category == _category;
      final matchesSearch = p.name.toLowerCase().contains(_search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: const [CartButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                _buildGrid(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),

          // Arama
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: InputDecoration(
              hintText: 'Ürün ara...',
              prefixIcon: const Icon(Icons.search, color: AppColors.mauve),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.blush),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.blush),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Kategoriler
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _categories.map((c) {
                final selected = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: selected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: AppColors.plum,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.blush),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.mauve,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final items = _filtered;

    if (items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('Aradığın ürün bulunamadı', style: TextStyle(color: AppColors.mauve)),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = items[index];
            return ProductCard(
              product: product,
              // Route arguments ile ürünü detay sayfasına gönder
              onTap: () => Navigator.pushNamed(
                context,
                ProductDetailPage.routeName,
                arguments: product,
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
