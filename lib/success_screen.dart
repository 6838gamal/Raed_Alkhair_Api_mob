import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/strings.dart';

class SuccessScreen extends ConsumerWidget {
  final String orderId;
  const SuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(t(ref, 'thanks')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF1DE9B6), size: 96),
            const SizedBox(height: 30),
            Text(t(ref, 'thanks_for_order'),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            Text('${t(ref, 'your_order_no')} $orderId',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF673AB7))),
            const SizedBox(height: 40),
            Text(
              t(ref, 'order_processed_24h'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F5CC3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: Text(t(ref, 'continue_to_home'),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
