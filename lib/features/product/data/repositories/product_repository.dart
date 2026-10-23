// lib/features/product/data/repositories/product_repository.dart

import 'package:ecom_app/core/supabase/supabase_service.dart';
import '../models/product_model.dart';

class ProductRepository extends SupabaseService {
  /// Get all products with optional filters
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? search,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = client.from('products').select('''
        id,
        name,
        description,
        price,
        stock_quantity,
        image_url,
        category_id,
        created_at,
        category:categories(id, name)
      ''');

      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category_id', categoryId);
      }

      if (search != null && search.trim().isNotEmpty) {
        query = query.ilike('name', '%${search.trim()}%');
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List).map((e) => ProductModel.fromJson(e)).toList();
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Get single product by ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await client
          .from('products')
          .select('''
            id, name, description, price, stock_quantity, image_url,
            category_id, created_at,
            category:categories(id, name)
          ''')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return ProductModel.fromJson(response);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Get popular products (example: highest stock or newest)
  Future<List<ProductModel>> getPopularProducts({int limit = 10}) async {
    return getProducts(limit: limit);
  }

  /// Get best sellers (you can later improve with order_items count)
  Future<List<ProductModel>> getBestSellers({int limit = 10}) async {
    return getProducts(limit: limit);
  }
}
