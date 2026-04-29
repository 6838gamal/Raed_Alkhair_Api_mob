import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/strings.dart';
import 'state/locale_provider.dart';
import 'state/providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

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
      _snack(t(ref, 'fill_all_required'));
      return;
    }
    if (_passCtrl.text != _confirmCtrl.text) {
      _snack(t(ref, 'passwords_no_match'));
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
      _snack(result.message ?? t(ref, 'signup_failed'));
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;
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
                    Text(t(ref, 'signup_title'),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    _buildInput(lang, t(ref, 'membership_no'),
                        controller: _memberCtrl, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _buildInput(lang, t(ref, 'full_name'), controller: _nameCtrl),
                    const SizedBox(height: 12),
                    _buildInput(lang, t(ref, 'mobile_number'),
                        controller: _phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildInput(lang, t(ref, 'address_optional'), controller: _addressCtrl),
                    const SizedBox(height: 12),
                    branchesAsync.when(
                      data: (list) => _branchDropdown(lang, list.map((b) => MapEntry(b.id, b.name)).toList()),
                      loading: () => const Center(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(color: Colors.white))),
                      error: (e, _) => Text(t(ref, 'cant_load_branches'),
                          style: TextStyle(color: Colors.red.shade100)),
                    ),
                    const SizedBox(height: 12),
                    _buildInput(lang, t(ref, 'password'),
                        isPass: true, controller: _passCtrl),
                    const SizedBox(height: 12),
                    _buildInput(lang, t(ref, 'confirm_password'),
                        isPass: true, controller: _confirmCtrl),
                    const SizedBox(height: 24),
                    _buildBtn(t(ref, 'sign_up'), _loading ? null : _submit, loading: _loading),
                    const SizedBox(height: 12),
                    _buildBtn(t(ref, 'login'), () => Navigator.pop(context), isSecondary: true),
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

  Widget _branchDropdown(String lang, List<MapEntry<int, String>> branches) {
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
          hint: Text(t(ref, 'select_branch'),
              textAlign: lang == 'en' ? TextAlign.left : TextAlign.right),
          items: branches
              .map((b) => DropdownMenuItem<int>(value: b.key, child: Text(b.value)))
              .toList(),
          onChanged: (v) => setState(() => _branchId = v),
        ),
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
}
