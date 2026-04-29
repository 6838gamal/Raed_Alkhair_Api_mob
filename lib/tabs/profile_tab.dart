import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback onBack;
  const ProfileTab({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // حقول البيانات الشخصية
          _field("820815197"), _field("أريج عدنان حسن"), _field("0780330310"), _field("areej99"),
          const SizedBox(height: 20),
          
          // أزرار المحفظة البنفسجية
          _actionBtn("رصيد محفظتي الجنوبية"),
          const SizedBox(height: 10),
          _actionBtn("رصيد محفظتي الشمالية"),
          
          const SizedBox(height: 15),

          // شريط عناوين الجدول (اللون الداكن)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF311B92), // كحلي داكن جداً
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("النقاط", style: TextStyle(color: Colors.white)),
                Text("حالة الطلبية", style: TextStyle(color: Colors.white)),
                Text("رقم الفاتورة", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // زر الرجوع للصفحة الرئيسية
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2), // لون فاتح للرجوع
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              onPressed: onBack,
              child: const Text("الرجوع إلى الصفحة الرئيسية", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String text) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
    child: Text(text, textAlign: TextAlign.right),
  );

  Widget _actionBtn(String text) => SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF673AB7), // اللون البنفسجي للأزرار
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );
}
