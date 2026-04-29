import 'package:flutter/material.dart';

class MainTab extends StatelessWidget {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/product_bg.jpg'), // صورة الشامبو
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
