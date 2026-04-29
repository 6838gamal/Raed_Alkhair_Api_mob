import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final Map<String, String> product;
  const OrderScreen({super.key, required this.product});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0; // الكمية الابتدائية كما في الصورة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(widget.product['name'] ?? "تفاصيل المنتج"),
        actions: [
          _buildCartBadge(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // الجزء العلوي: الاسم، السعر، والتقييم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.product['name'] ?? "كريم شجرة الشاي",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("6pv", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text("سعر العضو: 11.088", style: TextStyle(color: Colors.blueGrey)),
                          Text("سعر غير العضو: 14.245", style: TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // صورة المنتج
            Image.asset(
              widget.product['img'] ?? 'assets/images/tea_tree.jpg',
              height: 250,
              fit: BoxFit.contain,
            ),

            // الوصف
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "كريم شجرة الشاي هو كريم مفيد للجلد و مهدئ تم اعداده باستخدام زيت شجرة الشاي النقي هو منظف للدهون الزائدة (لحب الدهون والمديبات) ويمتصها بسرعة من خلال الجلد السليم كريم شجرة الشاي هو مناسب جدا للنظافة البشرة وحمايتها وهو أمن لجميع أفراد الأسرة",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5),
              ),
            ),

            const SizedBox(height: 10),

            // أزرار التحكم بالكمية
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 35, color: Colors.grey),
                  onPressed: () => setState(() => _quantity = 0),
                ),
                const SizedBox(width: 20),
                _quantityBtn(Icons.remove, () {
                  if (_quantity > 0) setState(() => _quantity--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("$_quantity", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                _quantityBtn(Icons.add, () => setState(() => _quantity++)),
              ],
            ),

            const SizedBox(height: 30),

            // أزرار الإجراءات (شراء، سلة، اطلب المزيد)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _actionButton("شراء", const Color(0xFF1DE9B6), () {}), // لون أخضر مائي
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _actionButton("الانتقال الى السلة", const Color(0xFF673AB7), () {})), // بنفسجي
                      const SizedBox(width: 10),
                      Expanded(child: _actionButton("اطلب المزيد", const Color(0xFFFFA000), () {})), // برتقالي
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

  // ويدجت زر الكمية (+ و -)
  Widget _quantityBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.deepPurple),
        onPressed: onPressed,
      ),
    );
  }

  // ويدجت الأزرار الملونة
  Widget _actionButton(String title, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // أزرار مربعة كما في الصورة
        ),
        onPressed: onPressed,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ويدجت السلة العلوية
  Widget _buildCartBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {}),
        Positioned(
          right: 8, top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
            child: const Text('0', style: TextStyle(color: Colors.white, fontSize: 9), textAlign: TextAlign.center),
          ),
        )
      ],
    );
  }
}
