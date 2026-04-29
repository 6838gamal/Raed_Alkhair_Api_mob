import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final String categoryName;
  const SubCategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // محاكاة لبيانات المنتجات الموجودة في الصورة
    final List<Map<String, String>> products = [
      {"name": "معجون أسنان جانوزي", "price": "11.088", "pv": "6pv", "img": "assets/images/product1.jpg"},
      {"name": "كريم شجرة الشاي", "price": "11.088", "pv": "6pv", "img": "assets/images/product2.jpg"},
      {"name": "بودرة تالكوم", "price": "12.500", "pv": "9pv", "img": "assets/images/product3.jpg"},
      {"name": "زيت مساج جانو", "price": "14.553", "pv": "9pv", "img": "assets/images/product4.jpg"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(categoryName), // يظهر "منتجات العناية الشخصية" مثلاً
        actions: [IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {})],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _productItem(products[index]);
        },
      ),
    );
  }

  Widget _productItem(Map<String, String> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(icon: const Icon(Icons.favorite_border, color: Colors.grey), onPressed: () {}),
          ),
          Expanded(child: Image.asset(product['img']!, fit: BoxFit.contain)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product['price']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(product['pv']!, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(product['name']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Text("يتم التوصيل عادة خلال 72 ساعة", style: TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
