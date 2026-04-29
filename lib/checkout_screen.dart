import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/strings.dart';
import 'state/providers.dart';
import 'success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String paymentMethod;
  const CheckoutScreen({super.key, this.paymentMethod = 'member'});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _deliveryFeeCtrl = TextEditingController(text: '0');
  bool _submitting = false;

  @override
  void dispose() {
    _deliveryFeeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cart = ref.read(cartServiceProvider);
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t(ref, 'cart_empty'))));
      return;
    }
    setState(() => _submitting = true);
    final fee = double.tryParse(_deliveryFeeCtrl.text.trim()) ?? 0;
    final result = await cart.checkout(paymentMethod: widget.paymentMethod, deliveryFee: fee);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (result == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t(ref, 'send_failed'))));
      return;
    }
    ref.read(cartTickProvider.notifier).bump();
    final orderId = result['order_id']?.toString() ?? result['id']?.toString() ?? '—';
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(orderId: orderId)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.read(cartServiceProvider);
    ref.watch(cartTickProvider);
    final user = ref.read(authServiceProvider).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(t(ref, 'confirm_order')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _summaryCard(cart, user),
            const SizedBox(height: 16),
            _readonlyField(
                t(ref, 'payment_method'),
                widget.paymentMethod == 'member'
                    ? t(ref, 'member_price')
                    : t(ref, 'non_member_price')),
            const SizedBox(height: 12),
            TextField(
              controller: _deliveryFeeCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: t(ref, 'delivery_fee'),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F5CC3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(t(ref, 'send_order'),
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(cart, user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${t(ref, 'buyer')}: ${user?.fullName ?? '—'}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('${t(ref, 'membership_no')}: ${user?.memberNumber ?? '—'}'),
          const Divider(),
          ...cart.items.map<Widget>((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('×${item.quantity}'),
                    Expanded(
                        child: Text(item.product.name,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis)),
                  ],
                ),
              )),
          const Divider(),
          Text('${t(ref, 'item_count')}: ${cart.items.length}'),
          Text('${t(ref, 'total_pv')}: ${cart.totalPV.toStringAsFixed(1)}pv'),
          Text('${t(ref, 'price_for_member')}: ${cart.totalMember.toStringAsFixed(3)}'),
          Text('${t(ref, 'price_for_non_member')}: ${cart.totalNonMember.toStringAsFixed(3)}'),
        ],
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return InputDecorator(
      decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(value),
    );
  }
}
