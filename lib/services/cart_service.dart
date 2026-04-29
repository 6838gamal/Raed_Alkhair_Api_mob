import 'package:dio/dio.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import 'api_client.dart';

class CartService {
  final Dio _dio = ApiClient.instance.dio;
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPV => _items.fold(0.0, (s, i) => s + i.pvSubtotal);
  double get totalMember => _items.fold(0.0, (s, i) => s + i.memberSubtotal);
  double get totalNonMember => _items.fold(0.0, (s, i) => s + i.nonMemberSubtotal);
  int get count => _items.fold(0, (s, i) => s + i.quantity);

  Future<bool> add(Product product, {int quantity = 1}) async {
    try {
      final res = await _dio.post(
        '/cart/add',
        data: {'product_id': product.id, 'quantity': quantity},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (res.statusCode != null && res.statusCode! < 400) {
        final existing = _items.indexWhere((i) => i.product.id == product.id);
        if (existing >= 0) {
          _items[existing].quantity += quantity;
        } else {
          _items.add(CartItem(product: product, quantity: quantity));
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> update(int productId, int quantity) async {
    try {
      final res = await _dio.post(
        '/cart/update',
        data: {'product_id': productId, 'quantity': quantity},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (res.statusCode != null && res.statusCode! < 400) {
        final idx = _items.indexWhere((i) => i.product.id == productId);
        if (idx >= 0) {
          if (quantity <= 0) {
            _items.removeAt(idx);
          } else {
            _items[idx].quantity = quantity;
          }
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(int productId) async {
    try {
      final res = await _dio.post(
        '/cart/remove',
        data: {'product_id': productId},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (res.statusCode != null && res.statusCode! < 400) {
        _items.removeWhere((i) => i.product.id == productId);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> clearLocal() async {
    for (final item in List<CartItem>.from(_items)) {
      await remove(item.product.id);
    }
    _items.clear();
  }

  Future<Map<String, dynamic>?> checkout({
    required String paymentMethod,
    double deliveryFee = 0,
  }) async {
    try {
      final res = await _dio.post(
        '/checkout',
        data: {'payment_method': paymentMethod, 'delivery_fee': deliveryFee},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      String? orderId;
      final location = res.headers.value('location') ?? '';
      final match = RegExp(r'/orders/(\d+)').firstMatch(location);
      if (match != null) orderId = match.group(1);

      if (orderId == null && res.realUri.path.isNotEmpty) {
        final m2 = RegExp(r'/orders/(\d+)').firstMatch(res.realUri.path);
        if (m2 != null) orderId = m2.group(1);
      }

      final isSuccess = (res.statusCode == 303 || res.statusCode == 302) &&
          !location.toLowerCase().contains('/cart');

      if (isSuccess || (res.statusCode != null && res.statusCode! < 400 && orderId != null)) {
        _items.clear();
        return {'order_id': orderId ?? '—'};
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        final loc = e.response?.headers.value('location') ?? '';
        final m = RegExp(r'/orders/(\d+)').firstMatch(loc);
        if (m != null) {
          _items.clear();
          return {'order_id': m.group(1)};
        }
      }
      return null;
    }
  }
}
