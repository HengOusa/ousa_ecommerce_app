// lib/features/cart/presentation/widgets/cart_item.dart

import 'package:ecom_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItem({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final product = cartItem.product; // ← fixed (singular)

    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // ==================== IMAGE ====================
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageUrl ?? '',
              width: 100,
              height: 95,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 100,
                  height: 95,
                  color: colors.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colors.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          // ==================== INFO ====================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Remove
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<CartProvider>().removeFromCart(product.id);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Description
                Text(
                  product.description ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const Spacer(),

                // Price + Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Quantity controls
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decrease
                          InkWell(
                            onTap: () {
                              context
                                  .read<CartProvider>()
                                  .decreaseQuantity(product.id);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(
                              width: 34,
                              height: 36,
                              child: Icon(Icons.remove, size: 17),
                            ),
                          ),

                          // Quantity number
                          SizedBox(
                            width: 36,
                            child: Center(
                              child: Text(
                                '${cartItem.quantity}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Increase
                          InkWell(
                            onTap: () {
                              context
                                  .read<CartProvider>()
                                  .increaseQuantity(product.id);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: const SizedBox(
                              width: 34,
                              height: 36,
                              child: Icon(Icons.add, size: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}