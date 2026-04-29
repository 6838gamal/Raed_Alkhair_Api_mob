import 'package:flutter/material.dart';

class OrderReviewScreen extends StatelessWidget {
  const OrderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text("تأكيد عملية الشراء"),
        centerTitle: true,
        actions: [
          _buildCartBadge(4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "ملاحظة: من فضلك تأكد من المعلومات قبل ارسال الطلب",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            
            // عرض صور المنتجات المختارة في السلة
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _productThumb('assets/images/shampoo.jpg'),
                _productThumb('assets/images/soap.jpg'),
                _productThumb('assets/images/massage_oil.jpg'),
                _productThumb('assets/images/tea_tree.jpg'),
              ],
            ),

            // الحاوية الرمادية التي تضم بيانات العميل
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // رمادي فاتح كما في الصورة
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _infoField("823095931"),
                  const SizedBox(height: 10),
                  _infoField("ابو امير"),
                  const SizedBox(height: 10),
                  _infoField("اونلاين النجف"),
                  const SizedBox(height: 10),
                  _infoField("قرية الغدير\nبلوك 102\nدار 27", maxLines: 3),
                  const SizedBox(height: 10),
                  _infoField("07829004883"),
                ],
              ),
            ),

            // جدول الحسابات (النقاط والسعر)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                children: [
                  _priceRow("مجموع النقاط", "27"),
                  _priceRow("مجموع السعر", "47.893"),
                  _priceRow("اجور التوصيل", "0"),
                  const Divider(),
                  _priceRow("المجموع الكلي", "47.893", isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // أزرار الإجراءات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _actionBtn("ارسال الطلب", const Color(0xFF1DE9B6))), // أخضر
                      const SizedBox(width: 10),
                      Expanded(child: _actionBtn("الغاء الطلب", Colors.red)), // أحمر
                    ],
                  ),
                  const SizedBox(height: 10),
                  _actionBtn("الدفع عن طريق المحفظة الجنوبية", Colors.grey),
                  const SizedBox(height: 10),
                  _actionBtn("رصيد محفظتك 0 د.ع", const Color(0xFF311B92)), // كحلي داكن
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ويدجت لعرض صور المنتجات الصغيرة
  Widget _productThumb(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(path, width: 40, height: 40, fit: BoxFit.contain),
    );
  }

  // ويدجت لحقول المعلومات داخل الحاوية الرمادية
  Widget _infoField(String text, {int maxLines = 1}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
      ),
    );
  }

  // ويدجت لصفوف الأسعار
  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[700], fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // ويدجت الأزرار
  Widget _actionBtn(String title, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCartBadge(int count) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {}),
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
