import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String orderId;
  const SuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text('شكراً'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF1DE9B6), size: 96),
            const SizedBox(height: 30),
            const Text('شكراً لطلبك',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),
            Text('رقم طلبك $orderId',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF673AB7))),
            const SizedBox(height: 40),
            const Text(
              "سيتم معالجة طلبك في غضون 24 ساعة\nشاكرين لك ثقتك بنا\n'شركة رائد الخير'",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
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
                child: const Text('متابعة إلى الصفحة الرئيسية',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
