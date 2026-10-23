import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecom_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedSize = 1;
  int selectedColor = 0;
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bool hasDiscount = product.hasDiscount;
    final int discountPercent = product.discountPercent;

    return Scaffold(
      // ====================== APP BAR ======================
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Product Details',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? colors.error : colors.onSurface,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),

      // ====================== BODY ======================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  color: colors.surfaceContainerHighest,
                  child: Image.network(
                    product.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),

                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // ================= PRODUCT INFO =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category / Brand
                  if (product.categoryName != null)
                    Text(
                      product.categoryName!.toUpperCase(),
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),

                  const SizedBox(height: 6),

                  // Name
                  Text(
                    product.name,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: colors.tertiary.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 16, color: colors.tertiary),
                            const SizedBox(width: 4),
                            Text(
                              (product.rating ?? 4.5).toStringAsFixed(1),
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'In Stock: ${product.stockQuantity}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: product.stockQuantity > 0
                              ? colors.primary
                              : colors.error,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 10),
                        Text(
                          '\$${product.originalPrice!.toStringAsFixed(2)}',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: colors.outlineVariant),
                  const SizedBox(height: 18),

                  // Description
                  Text(
                    'Description',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? 'No description available.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                              icon: const Icon(Icons.remove, size: 18),
                            ),
                            Text(
                              '$quantity',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: quantity < product.stockQuantity
                                  ? () => setState(() => quantity++)
                                  : null,
                              icon: const Icon(Icons.add, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Delivery info
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context: context,
                          icon: Icons.local_shipping_outlined,
                          title: 'Free Delivery',
                          subtitle: 'Delivery within 2–5 business days',
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          context: context,
                          icon: Icons.assignment_return_outlined,
                          title: '7 Days Return',
                          subtitle: 'Free return within 7 days',
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          context: context,
                          icon: Icons.verified_outlined,
                          title: 'Authentic Product',
                          subtitle: '100% genuine product guarantee',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),

      // ====================== BOTTOM BAR ======================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Add to Cart
              Expanded(
                child: OutlinedButton(
                  onPressed: product.stockQuantity > 0
                      ? () {
                          context.read<CartProvider>().addToCart(
                                product.id,
                                quantity: quantity,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      : null,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(color: colors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Buy Now
              Expanded(
                child: ElevatedButton(
                  onPressed: product.stockQuantity > 0
                      ? () {
                          // TODO: Go to checkout with this product
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    minimumSize: const Size(double.infinity, 52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Buy Now',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}