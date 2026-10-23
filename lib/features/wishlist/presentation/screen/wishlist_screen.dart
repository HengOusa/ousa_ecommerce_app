import 'package:flutter/material.dart';
import 'package:ecom_app/core/localization/translate_extension.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final products = [
      WishlistProduct(
        name: 'Nike Air Max 270',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
        price: 89.99,
        originalPrice: 129.99,
        rating: 4.8,
        reviews: 124,
      ),
      WishlistProduct(
        name: 'Apple Watch Series 9',
        imageUrl:
            'https://images.unsplash.com/photo-1546868871-7041f2a55e7a?w=600',
        price: 299.99,
        originalPrice: 399.99,
        rating: 4.7,
        reviews: 89,
      ),
      WishlistProduct(
        name: 'Premium Backpack',
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
        price: 49.99,
        originalPrice: 69.99,
        rating: 4.6,
        reviews: 56,
      ),
      WishlistProduct(
        name: 'Wireless Headphones',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
        price: 79.99,
        originalPrice: 109.99,
        rating: 4.9,
        reviews: 201,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'wishlist'.tr(context),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'more_options'.tr(context),
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SafeArea(
        child: products.isEmpty
            ? const EmptyWishlist()
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'saved_items'
                                  .tr(context)
                                  .replaceAll('{count}', '${products.length}'),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _SortButton(onTap: () {}),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: WishlistCard(
                            product: products[index],
                            onRemove: () {},
                            onAddToCart: () {},
                          ),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              ),
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final WishlistProduct product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(
            imageUrl: product.imageUrl,
            discount: product.discountPercentage,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      tooltip: 'remove_from_wishlist'.tr(context),
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.favorite, color: colors.error, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFB800),
                      size: 17,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.reviews})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 7,
                  runSpacing: 2,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                    Text(
                      '\$${product.originalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.shopping_bag_outlined, size: 17),
                    label: Text(
                      'add_to_cart'.tr(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  final double discount;

  const _ProductImage({required this.imageUrl, required this.discount});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 115,
      child: AspectRatio(
        aspectRatio: 0.85,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: colors.onSurfaceVariant,
                      size: 30,
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return Container(
                      color: colors.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (discount > 0)
              Positioned(
                top: 7,
                left: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.error,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '-${discount.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: colors.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SortButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.sort_rounded, size: 17),
      label: Text('sort'.tr(context)),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.onSurface,
        side: BorderSide(color: colors.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                color: colors.onErrorContainer,
                size: 48,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'empty_wishlist_title'.tr(context),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'empty_wishlist_description'.tr(context),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                minimumSize: const Size(0, 46),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('explore_products'.tr(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistProduct {
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviews;

  const WishlistProduct({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviews,
  });

  double get discountPercentage {
    if (originalPrice <= 0 || price >= originalPrice) return 0;
    return ((originalPrice - price) / originalPrice) * 100;
  }
}
