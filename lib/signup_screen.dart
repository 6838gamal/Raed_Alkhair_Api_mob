import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final Function(Locale) onLanguageChange;
  const SignUpScreen({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover))),
          Container(color: const Color(0xFF4A148C).withOpacity(0.65)),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text("إنشاء حساب جديد", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    _buildInput(lang, "رقم العضوية", "Membership No", "ژمارەی ئەندامیەتی"),
                    const SizedBox(height: 12),
                    _buildInput(lang, "الاسم الكامل", "Full Name", "ناوی تەواو"),
                    const SizedBox(height: 12),
                    _buildInput(lang, "رقم الموبايل", "Mobile Number", "ژمارەی مۆبایل"),
                    const SizedBox(height: 12),
                    _buildInput(lang, "كلمة السر", "Password", "وشەی نهێنی", isPass: true),
                    const SizedBox(height: 12),
                    _buildInput(lang, "تأكيد كلمة السر", "Confirm Password", "دوپاتکردنەوەی وشەی نهێنی", isPass: true),
                    const SizedBox(height: 30),
                    
                    // زر إنشاء الحساب -> يوجه للرئيسية مباشرة
                    _buildBtn(lang, "انشاء مستخدم جديد", "Sign Up", "تۆمارکردن", () {
                      Navigator.pushReplacementNamed(context, '/home');
                    }),
                    const SizedBox(height: 15),
                    
                    // زر تسجيل الدخول -> يعود للشاشة السابقة
                    _buildBtn(lang, "تسجيل الدخول", "Login", "چوونەژوورەوە", () {
                      Navigator.pop(context);
                    }, isSecondary: true),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- نفس الـ Widgets المساعدة (Input & Btn) من شاشة اللوجن تكرر هنا لتوحيد التصميم ---
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
}
