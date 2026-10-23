// lib/features/cart/data/repositories/cart_repository.dart

import 'package:ecom_app/core/supabase/supabase_service.dart';
import '../models/cart_item_model.dart';

class CartRepository extends SupabaseService {
  /// Get all cart items of the current user (with product details)
  Future<List<CartItemModel>> getCartItems(String userId) async {
    try {
      final response = await client
          .from('cart_items')
          .select('''
            id,
            user_id,
            product_id,
            quantity,
            created_at,
            product:products (
              id,
              name,
              description,
              price,
              stock_quantity,
              image_url,
              category_id
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Add product to cart (or increase quantity if already exists)
  Future<void> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
  }) async {
    try {
      // Check if item already exists
      final existing = await client
          .from('cart_items')
          .select('id, quantity')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        // Update quantity
        await client
            .from('cart_items')
            .update({'quantity': (existing['quantity'] as int) + quantity})
            .eq('id', existing['id']);
      } else {
        // Insert new item
        await client.from('cart_items').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
      }
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Update quantity of a cart item
  Future<void> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(cartItemId);
        return;
      }

      await client
          .from('cart_items')
          .update({'quantity': quantity})
          .eq('id', cartItemId);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await client.from('cart_items').delete().eq('id', cartItemId);
    } catch (e, st) {
      handleError(e, st);
    }
  }

  /// Clear entire cart of a user
  Future<void> clearCart(String userId) async {
    try {
      await client.from('cart_items').delete().eq('user_id', userId);
    } catch (e, st) {
      handleError(e, st);
    }
  }
}
