// lib/features/product/data/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stockQuantity;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;
  final DateTime? createdAt;

  // Optional UI fields (not in database yet)
  final double? originalPrice;
  final double? rating;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.createdAt,
    this.originalPrice,
    this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category'] != null
          ? (json['category'] as Map)['name'] as String?
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      originalPrice: json['original_price'] != null
          ? (json['original_price'] as num).toDouble()
          : null,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : 4.5, // default rating
    );
  }

  // Helpers for UI
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!hasDiscount || originalPrice == null || originalPrice == 0) {
      return 0;
    }
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
