import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_screen.dart';
import 'state/providers.dart';
import 'tabs/branches_tab.dart';
import 'tabs/main_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final Function(Locale) onLanguageChange;
  const HomeScreen({super.key, required this.onLanguageChange});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = _selectedIndex == 1 ? "اختر فرع" : "رائد الخير";
    final cart = ref.read(cartServiceProvider);
    ref.watch(cartTickProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        title: Text(appBarTitle),
        leading: _buildPopupMenu(context),
        actions: [
          _cartIcon(cart.count, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          }),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const MainTab(),
          const BranchesTab(),
          ProfileTab(onBack: () => setState(() => _selectedIndex = 0)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF9C27B0),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: "اختر فرع"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "بروفايل"),
        ],
      ),
    );
  }

  Widget _cartIcon(int count, VoidCallback onTap) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(icon: const Icon(Icons.shopping_basket_outlined), onPressed: onTap),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (val) async {
        if (val == 'logout') {
          await ref.read(authServiceProvider).logout();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        } else {
          widget.onLanguageChange(Locale(val));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'ku', child: Text("كوردى")),
        const PopupMenuItem(value: 'ar', child: Text("عربي")),
        const PopupMenuItem(value: 'en', child: Text("English")),
        const PopupMenuDivider(),
        const PopupMenuItem(
            value: 'logout', child: Text("تسجيل الخروج", style: TextStyle(color: Colors.red))),
      ],
    );
  }
}
