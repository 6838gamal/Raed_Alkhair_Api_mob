import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/catalog_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final catalogServiceProvider = Provider<CatalogService>((ref) => CatalogService());
final cartServiceProvider = Provider<CartService>((ref) => CartService());

final branchesProvider = FutureProvider<List<Branch>>((ref) async {
  return ref.read(catalogServiceProvider).fetchBranches();
});

final categoriesProvider =
    FutureProvider.family<List<CategoryModel>, int>((ref, branchId) async {
  return ref.read(catalogServiceProvider).fetchCategories(branchId);
});

final productsProvider =
    FutureProvider.family<List<Product>, int>((ref, categoryId) async {
  return ref.read(catalogServiceProvider).fetchProducts(categoryId);
});

class CartTick extends StateNotifier<int> {
  CartTick() : super(0);
  void bump() => state = state + 1;
}

final cartTickProvider = StateNotifierProvider<CartTick, int>((ref) => CartTick());
