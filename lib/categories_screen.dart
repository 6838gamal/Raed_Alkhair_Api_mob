import 'package:flutter/material.dart';
import 'sub_category_screen.dart'; // استيراد شاشة المنتجات

class CategoriesScreen extends StatelessWidget {
  final String branchName;
  const CategoriesScreen({super.key, required this.branchName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {"title": "المكملات الغذائية", "subtitle": "يتم التوصيل عادة خلال 72 ساعة", "image": "assets/images/supplements.jpg"},
      {"title": "منتجات العناية الشخصية", "subtitle": "يتم التوصيل عادة خلال 72 ساعة", "image": "assets/images/personal_care.jpg"},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: const Text("الفئات"),
        actions: [IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {})],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // عند الضغط يفتح شاشة المنتجات (Sub Categories)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryScreen(categoryName: categories[index]['title']!),
                ),
              );
            },
            child: _buildCategoryCard(categories[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(cat['image']!, height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(cat['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(cat['subtitle']!, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
