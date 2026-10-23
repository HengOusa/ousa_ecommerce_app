import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Title
              Text(
                'Order Summary',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // Subtotal
              _SummaryRow(
                label: 'Subtotal',
                value: '\$${cart.subTotal.toStringAsFixed(2)}',
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                valueStyle: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Shipping
              _SummaryRow(
                label: 'Shipping',
                value: cart.shipping == 0
                    ? 'Free'
                    : '\$${cart.shipping.toStringAsFixed(2)}',
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                valueStyle: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cart.shipping == 0 ? colors.primary : null,
                ),
              ),

              const SizedBox(height: 12),

              // Discount
              _SummaryRow(
                label: 'Discount',
                value: '-\$${cart.discount.toStringAsFixed(2)}',
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                valueStyle: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.error,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),

              // Total
              _SummaryRow(
                label: 'Total',
                value: '\$${cart.totalPrice.toStringAsFixed(2)}',
                labelStyle: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                valueStyle: textTheme.titleLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}