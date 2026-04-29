import 'package:flutter/material.dart';
import 'tabs/main_tab.dart';
import 'tabs/branches_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLanguageChange;
  const HomeScreen({super.key, required this.onLanguageChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // التبويب الافتراضي (الرئيسية)

  @override
  Widget build(BuildContext context) {
    // تحديد العنوان بناءً على التبويب النشط
    String appBarTitle = _selectedIndex == 1 ? "اختر فرع" : "رائد الخير";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0), // لون الـ AppBar البنفسجي
        foregroundColor: Colors.white,
        title: Text(appBarTitle),
        leading: _buildPopupMenu(context), // القائمة المنسدلة للغات
        actions: [
          IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: () {}),
        ],
      ),
      
      // التبديل بين الشاشات الفرعية مع الحفاظ على حالتها
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const MainTab(),      // الصفحة الرئيسية (المنتج)
          const BranchesTab(),  // صفحة الفروع
          ProfileTab(onBack: () => setState(() => _selectedIndex = 0)), // صفحة البروفايل
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF9C27B0),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "الصفحة الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: "اختر فرع"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "بروفايل"),
        ],
      ),
    );
  }

  // قائمة الثلاث نقاط المنسدلة
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (val) {
        if (val == 'logout') Navigator.pushReplacementNamed(context, '/');
        else widget.onLanguageChange(Locale(val));
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'ku', child: Text("كوردى")),
        const PopupMenuItem(value: 'ar', child: Text("عربي")),
        const PopupMenuItem(value: 'en', child: Text("English")),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'logout', child: Text("تسجيل الخروج", style: TextStyle(color: Colors.red))),
      ],
    );
  }
}
