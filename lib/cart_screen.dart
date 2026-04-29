import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'checkout_screen.dart';
import 'state/providers.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _busy = false;

  Future<void> _change(int productId, int newQty) async {
    setState(() => _busy = true);
    final cart = ref.read(cartServiceProvider);
    await cart.update(productId, newQty);
    if (!mounted) return;
    setState(() => _busy = false);
    ref.read(cartTickProvider.notifier).bump();
  }

  Future<void> _remove(int productId) async {
    setState(() => _busy = true);
    final cart = ref.read(cartServiceProvider);
    await cart.remove(productId);
    if (!mounted) return;
    setState(() => _busy = false);
    ref.read(cartTickProvider.notifier).bump();
  }

  Future<void> _clearAll() async {
    setState(() => _busy = true);
    await ref.read(cartServiceProvider).clearLocal();
    if (!mounted) return;
    setState(() => _busy = false);
    ref.read(cartTickProvider.notifier).bump();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.read(cartServiceProvider);
    ref.watch(cartTickProvider);
    final items = cart.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('سلة'),
        actions: [_buildCartBadge(cart.count)],
      ),
      body: items.isEmpty
          ? const Center(child: Text('السلة فارغة', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : Column(
              children: [
                _buildDeleteAllButton(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                _circleBtn(Icons.remove, () => _change(item.product.id, item.quantity - 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text("${item.quantity}",
                                      style: const TextStyle(fontSize: 16)),
                                ),
                                _circleBtn(Icons.add, () => _change(item.product.id, item.quantity + 1)),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item.product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                Text("${item.product.pvValue}pv",
                                    style: const TextStyle(color: Colors.grey)),
                                Text(
                                    "مجموع: ${item.pvSubtotal.toStringAsFixed(1)}pv",
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Stack(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  color: const Color(0xFFEDE7F6),
                                  child: item.product.imagePath != null && item.product.imagePath!.isNotEmpty
                                      ? Image.network(item.product.imagePath!,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.image, color: Color(0xFF9C27B0)))
                                      : const Icon(Icons.image, color: Color(0xFF9C27B0)),
                                ),
                                Positioned(
                                  right: -10,
                                  top: -10,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                    onPressed: () => _remove(item.product.id),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildBottomSection(cart.totalPV, cart.totalMember, cart.totalNonMember),
              ],
            ),
    );
  }

  Widget _buildDeleteAllButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8E24AA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: _busy ? null : _clearAll,
        child: const Text('حذف السلة',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: _busy ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.deepPurple.shade200)),
        child: Icon(icon, size: 18, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildBottomSection(double pv, double member, double nonMember) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text('مجموع النقاط: PV ${pv.toStringAsFixed(1)}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('سعر العضو: ${member.toStringAsFixed(3)}',
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('سعر غير العضو: ${nonMember.toStringAsFixed(3)}',
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
          ),
          const SizedBox(height: 15),
          _actionBtn('اكمال عملية الشراء بسعر العضو', const Color(0xFF1DE9B6),
              () => _goCheckout('member')),
          const SizedBox(height: 10),
          _actionBtn('اكمال عملية الشراء بسعر غير العضو', const Color(0xFF9C27B0),
              () => _goCheckout('non_member')),
        ],
      ),
    );
  }

  void _goCheckout(String paymentMethod) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CheckoutScreen(paymentMethod: paymentMethod)),
    );
  }

  Widget _actionBtn(String title, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: onTap,
        child: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCartBadge(int count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {}),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          )
      ],
    );
  }
}
