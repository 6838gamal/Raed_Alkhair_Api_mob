import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl(),
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: false,
      validateStatus: (s) => s != null && s < 500,
    ));
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  Dio get dio => _dio;

  static String _baseUrl() {
    if (kIsWeb) return '';
    return 'https://raed-alkhair-api.onrender.com';
  }
}
