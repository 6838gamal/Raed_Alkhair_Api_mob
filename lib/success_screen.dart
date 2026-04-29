import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String orderId = "17808"; // رقم الطلب كما في الصورة

  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text("شكراً"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _buildCartBadge(0), // السلة تصبح فارغة بعد الطلب
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الشعارات في الأعلى
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network('https://via.placeholder.com/100x50?text=DXN', width: 100), // استبدلها بشعار DXN
                Image.network('https://via.placeholder.com/100x50?text=RAED', width: 100), // استبدلها بشعار رائد الخير
              ],
            ),
            
            const SizedBox(height: 50),

            // نصوص الشكر ورقم الطلب
            const Text(
              "شكراً لطلبك",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              "رقم طلبك $orderId",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF673AB7)),
            ),

            const SizedBox(height: 40),

            // الرسالة التوضيحية
            const Text(
              "سيتم معالجة طلبك في غضون 24 ساعة\nشاكرين لك ثقتك بنا\nوكن متأكد إن فريق العمل جاهز لخدمتك\nونتمنى لك مزيد من التألق والنجاح\n'شركة رائد الخير'",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.6),
            ),

            const Spacer(),

            // الأزرار السفلية
            Row(
              children: [
                Expanded(child: _bottomButton("تابع طلبي", () {})),
                const SizedBox(width: 15),
                Expanded(child: _bottomButton("متابعة الى صفحة رئيسية", () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                })),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton(String title, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F5CC3), // نفس لون زر شاشة العنوان
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
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
            right: 8, top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
            ),
          )
      ],
    );
  }
}
