import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final Function(Locale) onLanguageChange;
  const SignUpScreen({super.key, required this.onLanguageChange});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _memberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  int? _branchId;
  bool _loading = false;

  @override
  void dispose() {
    _memberCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_memberCtrl.text.trim().isEmpty ||
        _nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _passCtrl.text.isEmpty ||
        _branchId == null) {
      _snack('الرجاء تعبئة كل الحقول الإلزامية واختيار الفرع');
      return;
    }
    if (_passCtrl.text != _confirmCtrl.text) {
      _snack('كلمتا السر غير متطابقتين');
      return;
    }
    setState(() => _loading = true);
    final auth = ref.read(authServiceProvider);
    final result = await auth.register(
      memberNumber: _memberCtrl.text.trim(),
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      preferredBranchId: _branchId!,
      password: _passCtrl.text,
      confirmPassword: _confirmCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _snack(result.message ?? 'فشل إنشاء الحساب');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    String lang = Localizations.localeOf(context).languageCode;
    final branchesAsync = ref.watch(branchesProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover))),
          Container(color: const Color(0xFF4A148C).withOpacity(0.65)),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text("إنشاء حساب جديد",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    _buildInput(lang, "رقم العضوية", "Membership No", "ژمارەی ئەندامیەتی",
                        controller: _memberCtrl, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildInput(lang, "الاسم الكامل", "Full Name", "ناوی تەواو", controller: _nameCtrl),
                    const SizedBox(height: 12),
                    _buildInput(lang, "رقم الموبايل", "Mobile Number", "ژمارەی مۆبایل",
                        controller: _phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildInput(lang, "العنوان (اختياري)", "Address (optional)", "ناونیشان", controller: _addressCtrl),
                    const SizedBox(height: 12),
                    branchesAsync.when(
                      data: (list) => _branchDropdown(list.map((b) => MapEntry(b.id, b.name)).toList()),
                      loading: () => const Center(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(color: Colors.white))),
                      error: (e, _) => Text('تعذر جلب الفروع', style: TextStyle(color: Colors.red.shade100)),
                    ),
                    const SizedBox(height: 12),
                    _buildInput(lang, "كلمة السر", "Password", "وشەی نهێنی",
                        isPass: true, controller: _passCtrl),
                    const SizedBox(height: 12),
                    _buildInput(lang, "تأكيد كلمة السر", "Confirm Password", "دوپاتکردنەوەی وشەی نهێنی",
                        isPass: true, controller: _confirmCtrl),
                    const SizedBox(height: 24),
                    _buildBtn(lang, "انشاء مستخدم جديد", "Sign Up", "تۆمارکردن",
                        _loading ? null : _submit,
                        loading: _loading),
                    const SizedBox(height: 12),
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

  Widget _branchDropdown(List<MapEntry<int, String>> branches) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: _branchId,
          hint: const Text('اختر الفرع المفضل', textAlign: TextAlign.right),
          items: branches
              .map((b) => DropdownMenuItem<int>(value: b.key, child: Text(b.value)))
              .toList(),
          onChanged: (v) => setState(() => _branchId = v),
        ),
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
}
