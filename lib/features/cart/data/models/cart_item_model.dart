// lib/features/cart/data/models/cart_item_model.dart

import 'package:ecom_app/features/product/data/models/product_model.dart';

class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final DateTime? createdAt;
  final ProductModel product; // joined product data

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.createdAt,
    required this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  // Helpful for updating quantity
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      userId: userId,
      productId: productId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt,
      product: product,
    );
  }
}