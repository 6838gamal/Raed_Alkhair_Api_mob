import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // خلفية رمادية فاتحة جداً كما في الصورة
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text("اضافة عنوان"),
        actions: [
          _buildCartBadge(4), // عدد العناصر الظاهر في صورتك هو 4
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField("رقم العضوية"),
            const SizedBox(height: 15),
            _buildInputField("الاسم"),
            const SizedBox(height: 15),
            _buildInputField("اونلاين النجف"), // هذا الحقل يبدو أنه لاختيار الفرع أو المنطقة
            const SizedBox(height: 15),
            _buildInputField("العنوان"),
            const SizedBox(height: 15),
            _buildInputField("رقم التلفون"),
            const SizedBox(height: 15),
            _buildInputField("الملاحظات", maxLines: 5), // حقل الملاحظات أكبر قليلاً
            
            const SizedBox(height: 40),
            
            // زر اكمال عملية الشراء
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F5CC3), // لون بنفسجي مائل للأزرق كما في الصورة
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // زوايا دائرية كبيرة للزر
                  ),
                ),
                onPressed: () {
                  // منطق إنهاء الطلب وإرساله لقاعدة البيانات
                },
                child: const Text(
                  "اكمال عملية الشراء",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت موحدة لبناء حقول الإدخال لتطابق التصميم
  Widget _buildInputField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      textAlign: TextAlign.right, // الكتابة من اليمين
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF9C27B0)),
        ),
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
