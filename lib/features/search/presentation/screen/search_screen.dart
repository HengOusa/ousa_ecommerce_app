import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _recentSearches = [
    'Nike Air Max',
    'Adidas shoes',
    'Men T-shirt',
  ];

  final List<String> _popularSearches = [
    'Nike',
    'Adidas',
    'Shoes',
    'T-shirt',
    'Jacket',
    'Backpack',
    'Watch',
    'Headphones',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    final value = query.trim();

    if (value.isEmpty) return;

    setState(() {
      _recentSearches.removeWhere(
        (item) => item.toLowerCase() == value.toLowerCase(),
      );
      _recentSearches.insert(0, value);

      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });

    // Connect your product search provider or API here.
    FocusScope.of(context).unfocus();
  }

  void _selectSearch(String value) {
    setState(() {
      _searchController.text = value;
      _searchController.selection = TextSelection.collapsed(
        offset: value.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          tooltip: 'back'.tr(context),
        ),
        title: Text(
          'search'.tr(context),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  onChanged: (_) => setState(() {}),
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'search_products'.tr(context),
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            tooltip: 'clear_search'.tr(context),
                            icon: const Icon(Icons.close, size: 20),
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Recent searches
              _buildSectionHeader(
                context,
                title: 'recent_searches'.tr(context),
                action: 'clear_all'.tr(context),
                actionColor: colors.error,
                onAction: () {
                  setState(() => _recentSearches.clear());
                },
              ),

              const SizedBox(height: 12),

              if (_recentSearches.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'no_recent_searches'.tr(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ..._recentSearches.map(
                  (item) => _buildRecentSearch(
                    context,
                    text: item,
                    onTap: () => _selectSearch(item),
                    onRemove: () {
                      setState(() => _recentSearches.remove(item));
                    },
                  ),
                ),

              const SizedBox(height: 25),

              // Popular searches
              _buildSectionTitle(context, 'popular_searches'.tr(context)),

              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _popularSearches.map((item) {
                  return _buildSearchChip(
                    context,
                    text: item,
                    onTap: () => _selectSearch(item),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Categories
              _buildSectionTitle(context, 'shop_by_category'.tr(context)),

              const SizedBox(height: 15),

              SizedBox(
                height: 105,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategory(
                      context,
                      icon: Icons.checkroom,
                      title: 'fashion'.tr(context),
                      onTap: () => _selectSearch('Fashion'),
                    ),
                    _buildCategory(
                      context,
                      icon: Icons.directions_run,
                      title: 'shoes'.tr(context),
                      onTap: () => _selectSearch('Shoes'),
                    ),
                    _buildCategory(
                      context,
                      icon: Icons.watch,
                      title: 'watches'.tr(context),
                      onTap: () => _selectSearch('Watches'),
                    ),
                    _buildCategory(
                      context,
                      icon: Icons.phone_android,
                      title: 'electronics'.tr(context),
                      onTap: () => _selectSearch('Electronics'),
                    ),
                    _buildCategory(
                      context,
                      icon: Icons.shopping_bag,
                      title: 'bags'.tr(context),
                      onTap: () => _selectSearch('Bags'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Trending products
              _buildSectionHeader(
                context,
                title: 'trending_products'.tr(context),
                action: 'see_all'.tr(context),
                actionColor: colors.primary,
                onAction: () {
                  // Navigate to your product listing screen.
                },
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 275,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildProductCard(
                      context,
                      image:
                          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
                      name: 'Nike Air Max 270',
                      price: '\$120',
                      rating: '4.8',
                    ),
                    _buildProductCard(
                      context,
                      image:
                          'https://images.unsplash.com/photo-1552346154-21d32810aba3?w=600',
                      name: 'Nike Running Shoes',
                      price: '\$95',
                      rating: '4.7',
                    ),
                    _buildProductCard(
                      context,
                      image:
                          'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=600',
                      name: 'Adidas Sneakers',
                      price: '\$110',
                      rating: '4.9',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String action,
    required Color actionColor,
    required VoidCallback onAction,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            action,
            style: theme.textTheme.labelLarge?.copyWith(
              color: actionColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearch(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.history, color: colors.onSurfaceVariant, size: 21),
          const SizedBox(width: 14),
          Expanded(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(text, style: theme.textTheme.bodyMedium),
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: 'remove'.tr(context),
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.close, size: 18, color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 85,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Icon(icon, size: 28, color: colors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required String image,
    required String name,
    required String price,
    required String rating,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                image,
                height: 165,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 165,
                  color: colors.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Material(
                  color: colors.surface,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () {
                      // Connect to your WishlistProvider here.
                    },
                    tooltip: 'add_to_wishlist'.tr(context),
                    constraints: const BoxConstraints.tightFor(
                      width: 36,
                      height: 36,
                    ),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.favorite_border,
                      size: 19,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
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
