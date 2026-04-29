import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/strings.dart';
import 'state/locale_provider.dart';
import 'state/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _memberCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _memberCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (_memberCtrl.text.trim().isEmpty || _passwordCtrl.text.isEmpty) {
      _showSnack(t(ref, 'login_required_fields'));
      return;
    }
    setState(() => _loading = true);
    final auth = ref.read(authServiceProvider);
    final result = await auth.login(
      memberNumber: _memberCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnack(result.message ?? t(ref, 'login_failed'));
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _setLang(String code) {
    ref.read(localeProvider.notifier).setLocale(code);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
            ),
          ),
          Container(color: const Color(0xFF4A148C).withOpacity(0.65)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(t(ref, 'app_title'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(t(ref, 'app_subtitle'),
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center),
                  const Spacer(),
                  _buildInput(lang, t(ref, 'membership_no'),
                      controller: _memberCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  _buildInput(lang, t(ref, 'password'),
                      isPass: true, controller: _passwordCtrl),
                  const SizedBox(height: 30),
                  _buildBtn(t(ref, 'login'), _loading ? null : _doLogin, loading: _loading),
                  const SizedBox(height: 15),
                  _buildBtn(t(ref, 'create_account'), () {
                    Navigator.pushNamed(context, '/signup');
                  }, isSecondary: true),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _langOption('Kurdî', 'ku', lang),
                      _langOption('English', 'en', lang),
                      _langOption('العربية', 'ar', lang),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String lang, String hint,
      {bool isPass = false, TextEditingController? controller, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      keyboardType: keyboardType,
      textAlign: lang == 'en' ? TextAlign.left : TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
    );
  }

  Widget _buildBtn(String label, VoidCallback? press,
      {bool isSecondary = false, bool loading = false}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary
              ? const Color(0xFF673AB7).withOpacity(0.8)
              : const Color(0xFF673AB7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _langOption(String label, String code, String currentLang) {
    final selected = currentLang == code;
    return TextButton(
      onPressed: () => _setLang(code),
      child: Text(label,
          style: TextStyle(
              color: selected ? Colors.amber : Colors.white,
              fontSize: 13,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
