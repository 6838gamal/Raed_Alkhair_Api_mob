import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // بيانات تجريبية للمنتجات الموجودة في السلة كما في الصورة
  List<Map<String, dynamic>> cartItems = [
    {"name": "كريم شجرة الشاي", "pv": 6, "quantity": 1, "img": "assets/images/tea_tree.jpg"},
    {"name": "زيت مساج جانو", "pv": 9, "quantity": 1, "img": "assets/images/massage_oil.jpg"},
    {"name": "صابون جانوزي", "pv": 5, "quantity": 1, "img": "assets/images/soap.jpg"},
    {"name": "ألوفيرا لوشن للجسم والأيدي", "pv": 7, "quantity": 1, "img": "assets/images/aloe_lotion.jpg"},
  ];

  double get totalPV => cartItems.fold(0, (sum, item) => sum + (item['pv'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text("سلة"),
        actions: [
          _buildCartBadge(cartItems.length),
        ],
      ),
      body: Column(
        children: [
          // زر حذف السلة العلوي
          _buildDeleteAllButton(),
          
          // قائمة المنتجات
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildCartItem(index),
            ),
          ),

          // مجموع النقاط وأزرار الإكمال
          _buildBottomSection(),
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
        onPressed: () => setState(() => cartItems.clear()),
        child: const Text("حذف السلة", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = cartItems[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // أزرار التحكم بالكمية (يسار)
          Row(
            children: [
              _circleBtn(Icons.remove, () => setState(() => item['quantity'] > 1 ? item['quantity']-- : null)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text("${item['quantity']}", style: const TextStyle(fontSize: 16)),
              ),
              _circleBtn(Icons.add, () => setState(() => item['quantity']++)),
            ],
          ),
          
          const Spacer(),

          // تفاصيل المنتج (منتصف)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${item['pv']}pv", style: const TextStyle(color: Colors.grey)),
              Text("مجموع: ${item['pv'] * item['quantity']}.0pv", style: const TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(width: 10),

          // صورة المنتج وزر الحذف (يمين)
          Stack(
            children: [
              Image.asset(item['img'], width: 60, height: 60, fit: BoxFit.contain),
              Positioned(
                right: -10,
                top: -10,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => setState(() => cartItems.removeAt(index)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.deepPurple.shade200)),
        child: Icon(icon, size: 18, color: Colors.deepPurple),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text("مجموع النقاط: PV $totalPV", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const SizedBox(height: 15),
          _actionBtn("اكمال عملية الشراء بسعر العضو", const Color(0xFF1DE9B6)),
          const SizedBox(height: 10),
          _actionBtn("اكمال عملية الشراء بسعر غير العضو", const Color(0xFF9C27B0)),
        ],
      ),
    );
  }

  Widget _actionBtn(String title, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () {},
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
