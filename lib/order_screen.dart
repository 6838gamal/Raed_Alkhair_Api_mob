import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_screen.dart';
import 'models/product.dart';
import 'state/providers.dart';

class OrderScreen extends ConsumerStatefulWidget {
  final Product product;
  const OrderScreen({super.key, required this.product});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  int _quantity = 1;
  bool _adding = false;

  Future<void> _addToCart({bool goToCart = false}) async {
    if (_quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر كمية أكبر من صفر')));
      return;
    }
    setState(() => _adding = true);
    final cart = ref.read(cartServiceProvider);
    final ok = await cart.add(widget.product, quantity: _quantity);
    if (!mounted) return;
    setState(() => _adding = false);
    if (ok) {
      ref.read(cartTickProvider.notifier).bump();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تمت إضافة ${widget.product.name} إلى السلة')),
      );
      if (goToCart) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر إضافة المنتج. سجّل الدخول أولاً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final cart = ref.read(cartServiceProvider);
    ref.watch(cartTickProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(p.name),
        actions: [
          _cartIcon(cart.count, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${p.pvValue}pv",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("سعر العضو: ${p.priceMember}",
                              style: const TextStyle(color: Colors.blueGrey)),
                          Text("سعر غير العضو: ${p.priceNonMember}",
                              style: const TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              child: p.imagePath != null && p.imagePath!.isNotEmpty
                  ? Image.network(p.imagePath!,
                      fit: BoxFit.contain, errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                p.description.isEmpty ? 'لا يوجد وصف لهذا المنتج' : p.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 35, color: Colors.grey),
                  onPressed: () => setState(() => _quantity = 1),
                ),
                const SizedBox(width: 20),
                _quantityBtn(Icons.remove, () {
                  if (_quantity > 1) setState(() => _quantity--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("$_quantity",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                _quantityBtn(Icons.add, () => setState(() => _quantity++)),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _actionButton(
                      _adding ? 'جارٍ الإضافة…' : 'شراء (إضافة وفتح السلة)',
                      const Color(0xFF1DE9B6),
                      _adding ? null : () => _addToCart(goToCart: true)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: _actionButton('إضافة إلى السلة', const Color(0xFF673AB7),
                              _adding ? null : () => _addToCart())),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _actionButton('فتح السلة', const Color(0xFFFFA000), () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      })),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFEDE7F6),
        child: const Center(child: Icon(Icons.image, size: 100, color: Color(0xFF9C27B0))),
      );

  Widget _quantityBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
      ),
      child: IconButton(icon: Icon(icon, color: Colors.deepPurple), onPressed: onPressed),
    );
  }

  Widget _actionButton(String title, Color color, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: onPressed,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

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
