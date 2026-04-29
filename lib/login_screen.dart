import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(Locale) onLanguageChange;
  const LoginScreen({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
            ),
          ),
          Container(color: const Color(0xFF4A148C).withOpacity(0.65)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text("شركة رائد الخير", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("الوكيل الحصري لشركة DXN العالمية في العراق", style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
                  const Spacer(),
                  _buildInput(lang, "رقم العضوية", "Membership No", "ژمارەی ئەندامیەتی"),
                  const SizedBox(height: 15),
                  _buildInput(lang, "كلمة السر", "Password", "وشەی نهێنی", isPass: true),
                  const SizedBox(height: 30),
                  
                  // زر تسجيل الدخول: ينتقل للشاشة الرئيسية ويمنع العودة للخلف
                  _buildBtn(lang, "تسجيل الدخول", "Login", "چوونەژوورەوە", () {
                    Navigator.pushReplacementNamed(context, '/home');
                  }),
                  const SizedBox(height: 15),
                  
                  // زر إنشاء حساب: ينتقل لشاشة الساين أب
                  _buildBtn(lang, "انشاء حساب", "Create Account", "دروستکردنی هەژمار", () {
                    Navigator.pushNamed(context, '/signup');
                  }, isSecondary: true),
                  
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _langOption("العربية", () => onLanguageChange(const Locale('ar'))),
                      _langOption("English", () => onLanguageChange(const Locale('en'))),
                      _langOption("Kurdî", () => onLanguageChange(const Locale('ku'))),
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

  // --- Widgets المساعدة ---
  Widget _buildInput(String lang, String ar, String en, String ku, {bool isPass = false}) {
    return TextField(
      obscureText: isPass,
      textAlign: lang == 'en' ? TextAlign.left : TextAlign.right,
      decoration: InputDecoration(
        hintText: lang == 'ar' ? ar : (lang == 'ku' ? ku : en),
        filled: true, fillColor: Colors.white.withOpacity(0.85),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
    );
  }

  Widget _buildBtn(String lang, String ar, String en, String ku, VoidCallback press, {bool isSecondary = false}) {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? const Color(0xFF673AB7).withOpacity(0.8) : const Color(0xFF673AB7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(lang == 'ar' ? ar : (lang == 'ku' ? ku : en), style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  Widget _langOption(String label, VoidCallback tap) {
    return TextButton(onPressed: tap, child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)));
  }
}
