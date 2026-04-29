import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_screen.dart';
import 'l10n/strings.dart';
import 'models/product.dart';
import 'order_screen.dart';
import 'state/providers.dart';

class SubCategoryScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;
  const SubCategoryScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider(categoryId));
    final cart = ref.read(cartServiceProvider);
    ref.watch(cartTickProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(categoryName),
        actions: [
          _cartIcon(cart.count, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          }),
        ],
      ),
      body: asyncProducts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text('${t(ref, 'cant_load_products')}\n$e', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(productsProvider(categoryId)),
                child: Text(t(ref, 'retry')),
              )
            ],
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return Center(child: Text(t(ref, 'no_products')));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => _productItem(context, ref, products[index]),
          );
        },
      ),
    );
  }

  Widget _productItem(BuildContext context, WidgetRef ref, Product p) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => OrderScreen(product: p)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Expanded(
              child: p.imagePath != null && p.imagePath!.isNotEmpty
                  ? Image.network(p.imagePath!,
                      fit: BoxFit.contain, errorBuilder: (_, __, ___) => _imgPlaceholder())
                  : _imgPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.priceMember,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text("${p.pvValue}pv",
                          style: const TextStyle(
                              color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(p.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(t(ref, 'delivery_72h'),
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        color: const Color(0xFFEDE7F6),
        child: const Center(child: Icon(Icons.image, size: 60, color: Color(0xFF9C27B0))),
      );

  Widget _cartIcon(int count, VoidCallback onTap) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: onTap),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }
}
