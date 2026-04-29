import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/providers.dart';

class ProfileTab extends ConsumerWidget {
  final VoidCallback onBack;
  const ProfileTab({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          if (user == null)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text('لم يتم تسجيل الدخول. الرجاء العودة لتسجيل الدخول.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            )
          else ...[
            _field(user.memberNumber.isEmpty ? '—' : user.memberNumber),
            _field(user.fullName.isEmpty ? '—' : user.fullName),
            _field(user.phone ?? '—'),
            _field(user.address ?? '—'),
          ],
          const SizedBox(height: 20),
          _actionBtn('رصيد محفظتي الجنوبية'),
          const SizedBox(height: 10),
          _actionBtn('رصيد محفظتي الشمالية'),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: const Color(0xFF311B92),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('النقاط', style: TextStyle(color: Colors.white)),
                Text('حالة الطلبية', style: TextStyle(color: Colors.white)),
                Text('رقم الفاتورة', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 100),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              onPressed: onBack,
              child: const Text('الرجوع إلى الصفحة الرئيسية',
                  style: TextStyle(color: Colors.white)),
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
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
        child: Text(text, textAlign: TextAlign.right),
      );

  Widget _actionBtn(String text) => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF673AB7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
          onPressed: () {},
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      );
}
