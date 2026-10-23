// lib/features/cart/presentation/widgets/add_to_cart_button.dart

import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecom_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:ecom_app/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          final cartProvider = context.read<CartProvider>();

          await cartProvider.addToCart(product.id); // ← pass product.id

          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: colors.onPrimary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${product.name} added to cart',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CartScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'VIEW CART',
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.add_shopping_cart,
            size: 18,
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}