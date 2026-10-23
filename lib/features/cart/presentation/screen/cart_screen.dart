// lib/features/cart/presentation/screens/cart_screen.dart

import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:ecom_app/core/widgets/primary_button.dart';
import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecom_app/features/cart/presentation/widgets/cart_item.dart';
import 'package:ecom_app/features/cart/presentation/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'shopping_cart'.tr(context),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          // Loading state
          if (cart.isLoading && cart.cartItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (cart.errorMessage != null && cart.cartItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: colors.error),
                    const SizedBox(height: 16),
                    Text(
                      cart.errorMessage!,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(color: colors.error),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => cart.loadCart(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final isEmpty = cart.isEmpty;

          return Column(
            children: [
              // ====================== SCROLLABLE CONTENT ======================
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => cart.loadCart(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item count
                        Text(
                          isEmpty
                              ? 'your_cart_is_empty'.tr(context)
                              : '${cart.cartCount} ${(cart.cartCount == 1 ? 'item' : 'items').tr(context)}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (isEmpty)
                          _buildEmptyCart(context, colors, textTheme)
                        else ...[
                          // Cart Items List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cart.cartItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return CartItem(
                                cartItem: cart.cartItems[index],
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          // Order Summary
                          const OrderSummary(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // ====================== CHECKOUT BAR ======================
              if (!isEmpty) _buildCheckoutBar(context, cart, colors, textTheme),
            ],
          );
        },
      ),
    );
  }

  // ====================== EMPTY STATE ======================
  Widget _buildEmptyCart(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: colors.onSurfaceVariant.withAlpha(150),
            ),
            const SizedBox(height: 20),
            Text(
              'your_cart_is_empty'.tr(context),
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to your cart to see them here.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== CHECKOUT BAR ======================
  Widget _buildCheckoutBar(
    BuildContext context,
    CartProvider cart,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Total price
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'total'.tr(context),
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${cart.totalPrice.toStringAsFixed(2)}',
                    style: textTheme.titleLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Checkout button
            Expanded(
              flex: 3,
              child: PrimaryButton(
                title: 'checkout'.tr(context),
                onPressed: () {
                  // context.pushNamed(AppRoutes.checkout);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}