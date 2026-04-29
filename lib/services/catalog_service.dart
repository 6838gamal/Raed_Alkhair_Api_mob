import 'package:dio/dio.dart';

import '../models/branch.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'api_client.dart';

class CatalogService {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<Branch>> fetchBranches() async {
    final res = await _dio.get('/api/branches');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(Branch.fromJson).toList();
  }

  Future<List<CategoryModel>> fetchCategories(int branchId) async {
    final res = await _dio.get('/api/branches/$branchId/categories');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(CategoryModel.fromJson).toList();
  }

  Future<List<Product>> fetchProducts(int categoryId) async {
    final res = await _dio.get('/api/categories/$categoryId/products');
    final list = (res.data as List).cast<Map<String, dynamic>>();
    return list.map(Product.fromJson).toList();
  }
}
