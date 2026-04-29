import 'package:flutter/material.dart';
import '../categories_screen.dart'; // استيراد شاشة الفئات

class BranchesTab extends StatelessWidget {
  const BranchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> branches = [
      "اونلاين الموصل", "اونلاين كركوك", "اونلاين تكريت", "اونلاين ديالى",
      "اونلاين الفلوجة", "اونلاين الرمادي", "اونلاين بابل", "اونلاين كربلاء",
      "اونلاين النجف", "اونلاين الناصرية", "اونلاين ميسان", "اونلاين البصرة",
      "اونلاين اربيل", "اونلاين بغداد"
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemCount: branches.length,
      itemBuilder: (context, index) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8E24AA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () {
          // عند الضغط يفتح شاشة الفئات (الأصناف)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriesScreen(branchName: branches[index]),
            ),
          );
        },
        child: Text(branches[index], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
