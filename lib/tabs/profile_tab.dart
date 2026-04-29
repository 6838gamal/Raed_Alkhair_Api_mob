import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/strings.dart';
import '../state/locale_provider.dart';
import '../state/providers.dart';

class ProfileTab extends ConsumerWidget {
  final VoidCallback onBack;
  const ProfileTab({super.key, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authServiceProvider).currentUser;
    final currentLang = ref.watch(localeProvider).languageCode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          if (user == null)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(t(ref, 'not_logged_in'),
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            )
          else ...[
            _field('${t(ref, 'membership_no')}: ${user.memberNumber.isEmpty ? '—' : user.memberNumber}'),
            _field('${t(ref, 'full_name')}: ${user.fullName.isEmpty ? '—' : user.fullName}'),
            _field('${t(ref, 'mobile_number')}: ${user.phone ?? '—'}'),
            _field('${t(ref, 'address_optional')}: ${user.address ?? '—'}'),
          ],
          const SizedBox(height: 20),
          _actionBtn(t(ref, 'wallet_south')),
          const SizedBox(height: 10),
          _actionBtn(t(ref, 'wallet_north')),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: const Color(0xFF311B92),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(t(ref, 'points'), style: const TextStyle(color: Colors.white)),
                Text(t(ref, 'order_status'), style: const TextStyle(color: Colors.white)),
                Text(t(ref, 'invoice_no'), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _languageSelector(ref, currentLang),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              onPressed: onBack,
              child: Text(t(ref, 'back_to_home'),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
              onPressed: () async {
                await ref.read(authServiceProvider).logout();
                if (!context.mounted) return;
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(t(ref, 'logout'),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageSelector(WidgetRef ref, String currentLang) {
    Widget chip(String label, String code) {
      final selected = currentLang == code;
      return Expanded(
        child: GestureDetector(
          onTap: () => ref.read(localeProvider.notifier).setLocale(code),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF9C27B0) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                )),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4, left: 4),
          child: Text(t(ref, 'language'),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        ),
        Row(
          children: [
            chip('العربية', 'ar'),
            chip('English', 'en'),
            chip('Kurdî', 'ku'),
          ],
        ),
      ],
    );
  }

  Widget _field(String text) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
        child: Text(text, textAlign: TextAlign.start),
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
