import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final Function(Locale) onLanguageChange;
  const LoginScreen({super.key, required this.onLanguageChange});

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
      _showSnack('الرجاء إدخال رقم العضوية وكلمة السر');
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
      _showSnack(result.message ?? 'فشل تسجيل الدخول');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

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
                  const Text("شركة رائد الخير",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("الوكيل الحصري لشركة DXN العالمية في العراق",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      textAlign: TextAlign.center),
                  const Spacer(),
                  _buildInput(lang, "رقم العضوية", "Membership No", "ژمارەی ئەندامیەتی",
                      controller: _memberCtrl, keyboardType: TextInputType.number),
                  const SizedBox(height: 15),
                  _buildInput(lang, "كلمة السر", "Password", "وشەی نهێنی",
                      isPass: true, controller: _passwordCtrl),
                  const SizedBox(height: 30),
                  _buildBtn(lang, "تسجيل الدخول", "Login", "چوونەژوورەوە",
                      _loading ? null : _doLogin,
                      loading: _loading),
                  const SizedBox(height: 15),
                  _buildBtn(lang, "انشاء حساب", "Create Account", "دروستکردنی هەژمار", () {
                    Navigator.pushNamed(context, '/signup');
                  }, isSecondary: true),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _langOption("العربية", () => widget.onLanguageChange(const Locale('ar'))),
                      _langOption("English", () => widget.onLanguageChange(const Locale('en'))),
                      _langOption("Kurdî", () => widget.onLanguageChange(const Locale('ku'))),
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

  Widget _buildInput(String lang, String ar, String en, String ku,
      {bool isPass = false, TextEditingController? controller, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      keyboardType: keyboardType,
      textAlign: lang == 'en' ? TextAlign.left : TextAlign.right,
      decoration: InputDecoration(
        hintText: lang == 'ar' ? ar : (lang == 'ku' ? ku : en),
        filled: true,
        fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
    );
  }

  Widget _buildBtn(String lang, String ar, String en, String ku, VoidCallback? press,
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
            : Text(lang == 'ar' ? ar : (lang == 'ku' ? ku : en),
                style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _langOption(String label, VoidCallback tap) {
    return TextButton(onPressed: tap, child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)));
  }
}
