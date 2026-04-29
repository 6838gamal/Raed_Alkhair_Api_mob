import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_screen.dart';
import 'l10n/strings.dart';
import 'state/locale_provider.dart';
import 'state/providers.dart';
import 'tabs/branches_tab.dart';
import 'tabs/main_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appBarTitle =
        _selectedIndex == 1 ? t(ref, 'tab_branches') : t(ref, 'app_title');
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
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: t(ref, 'tab_home')),
          BottomNavigationBarItem(icon: const Icon(Icons.menu_book_outlined), label: t(ref, 'tab_branches')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: t(ref, 'tab_profile')),
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
    final currentLang = ref.watch(localeProvider).languageCode;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (val) async {
        if (val == 'logout') {
          await ref.read(authServiceProvider).logout();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/');
        } else {
          await ref.read(localeProvider.notifier).setLocale(val);
        }
      },
      itemBuilder: (context) => [
        _langItem('ku', 'Kurdî', currentLang),
        _langItem('ar', 'العربية', currentLang),
        _langItem('en', 'English', currentLang),
        const PopupMenuDivider(),
        PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Text(t(ref, 'logout'), style: const TextStyle(color: Colors.red)),
              ],
            )),
      ],
    );
  }

  PopupMenuItem<String> _langItem(String code, String label, String currentLang) {
    final selected = currentLang == code;
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Icon(selected ? Icons.check_circle : Icons.language,
              size: 18, color: selected ? const Color(0xFF9C27B0) : Colors.grey),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: selected ? const Color(0xFF9C27B0) : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
