import 'package:dio/dio.dart';

import '../models/user.dart';
import 'api_client.dart';

class AuthResult {
  final bool success;
  final String? message;
  final AppUser? user;

  AuthResult({required this.success, this.message, this.user});
}

class AuthService {
  final Dio _dio = ApiClient.instance.dio;
  AppUser? currentUser;

  Future<AuthResult> login({required String memberNumber, required String password}) async {
    try {
      final res = await _dio.post(
        '/login',
        data: {
          'member_number': memberNumber,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      final location = (res.headers.value('location') ?? '').toLowerCase();
      final isRedirect = res.statusCode == 303 || res.statusCode == 302;
      final isSuccess = isRedirect && !location.startsWith('/login');

      if (isSuccess || res.statusCode == 200) {
        final data = res.data;
        if (data is Map && data['user'] is Map) {
          currentUser = AppUser.fromJson(Map<String, dynamic>.from(data['user']));
        } else {
          currentUser = AppUser(memberNumber: memberNumber, fullName: '');
        }
        return AuthResult(success: true, user: currentUser);
      }

      return AuthResult(
        success: false,
        message: 'رقم العضوية أو كلمة المرور غير صحيحة',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: 'خطأ في الاتصال: ${e.message ?? e.type.name}');
    } catch (e) {
      return AuthResult(success: false, message: 'خطأ غير متوقع: $e');
    }
  }

  Future<AuthResult> register({
    required String memberNumber,
    required String fullName,
    required String phone,
    required String address,
    required int preferredBranchId,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final res = await _dio.post(
        '/register',
        data: {
          'member_number': memberNumber,
          'full_name': fullName,
          'phone': phone,
          'address': address,
          'preferred_branch_id': preferredBranchId,
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      final location = (res.headers.value('location') ?? '').toLowerCase();
      final isRedirect = res.statusCode == 303 || res.statusCode == 302;
      final isSuccess = (res.statusCode == 200 || res.statusCode == 201) ||
          (isRedirect && !location.startsWith('/register'));

      if (isSuccess) {
        currentUser = AppUser(
          memberNumber: memberNumber,
          fullName: fullName,
          phone: phone,
          address: address,
          preferredBranchId: preferredBranchId,
        );
        return AuthResult(success: true, user: currentUser);
      }

      return AuthResult(
        success: false,
        message: 'تعذّر إنشاء الحساب — تأكد من البيانات أو أن رقم العضوية غير مستخدم',
      );
    } on DioException catch (e) {
      return AuthResult(success: false, message: 'خطأ في الاتصال: ${e.message ?? e.type.name}');
    } catch (e) {
      return AuthResult(success: false, message: 'خطأ غير متوقع: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.get('/logout', options: Options(followRedirects: false, validateStatus: (s) => s != null && s < 500));
    } catch (_) {}
    currentUser = null;
  }
}
