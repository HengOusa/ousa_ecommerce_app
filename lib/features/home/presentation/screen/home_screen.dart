import 'package:ecom_app/core/localization/translate_extension.dart';
import 'package:ecom_app/features/brand/presentation/widgets/brand_item.dart';
import 'package:ecom_app/features/category/data/category_data.dart';
import 'package:ecom_app/features/home/presentation/providers/home_provider.dart';
import 'package:ecom_app/features/product/data/models/product_model.dart';
import 'package:ecom_app/features/product/presentation/providers/product_provider.dart';
import 'package:ecom_app/features/product/presentation/widgets/product_card.dart';
import 'package:ecom_app/features/product/presentation/widgets/product_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Map<String, dynamic>> brands = [
    {
      'name': 'Nike',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/3/36/Logo_nike_principal.jpg',
    },
    {
      'name': 'Adidas',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOs28pOURaKo9MJYHAnfWB1jLkigoD036uqfdpSWoGt4NypITMmgbtqQpI&s=10',
    },
    {
      'name': 'Puma',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHEEy236whv57VKXHIw620_R0SnFmzl2cCQVGGi2garXLqiTc0I0SuCu0&s=10',
    },
    {
      'name': 'Apple',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSOYskah7TFc6y3OKdFAyrQKf4jUyT0w0UKpBxcG61umA&s=10',
    },
    {
      'name': 'Samsung',
      'image':
          'https://static.vecteezy.com/system/resources/previews/020/975/545/non_2x/samsung-logo-samsung-icon-transparent-free-png.png',
    },
  ];

  static const List<Map<String, String>> banners = [
    {
      'image':
          'https://cdn.dribbble.com/userupload/46804360/file/432a3adc9d37070c1874cfc52c0864fd.png?resize=400x0',
      'title': 'summer_sale',
    },
    {
      'image':
          'https://marketingweek.imgix.net/uploads/2024/10/02141716/shutterstock_2510340855-resize-1.jpg?auto=compress,format&crop=faces,entropy,edges&fit=crop&q=60&w=1200&h=624',
      'title': 'new_collection',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load products from Supabase when screen opens
    Future.microtask(() {
      context.read<ProductProvider>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final homeProvider = context.watch<HomeProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => productProvider.loadInitialData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                _buildHeader(context, colors, textTheme),

                const SizedBox(height: 20),

                // SEARCH BAR
                _buildSearchBar(context, colors, textTheme),

                const SizedBox(height: 10),

                // BANNERS
                SizedBox(
                  height: 155,
                  child: PageView.builder(
                    controller: homeProvider.bannerController,
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              banner['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  ColoredBox(color: colors.primaryContainer),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    colors.scrim.withAlpha(170),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: Text(
                                banner['title']!.tr(context),
                                style: textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // BRANDS
                _SectionTitle(
                  title: 'brands'.tr(context),
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: brands.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return BrandItem(name: 'all'.tr(context), onTap: () {});
                      }
                      final brand = brands[index - 1];
                      return BrandItem(
                        name: brand['name'] as String,
                        logo: brand['image'] as String,
                        onTap: () {},
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // CATEGORIES
                _SectionTitle(
                  title: 'categories'.tr(context),
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: CategoryData.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = CategoryData.categories[index];
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              category.tr(context),
                              style: textTheme.labelLarge?.copyWith(
                                color: colors.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ====================== POPULAR PRODUCTS ======================
                _SectionTitle(
                  title: 'popular'.tr(context),
                  textTheme: textTheme,
                  actionText: 'see_all'.tr(context),
                  onActionTap: () {
                    // TODO: Navigate to ProductScreen
                  },
                ),
                const SizedBox(height: 12),
                _ProductList(
                  products: productProvider.popularProducts,
                  isLoading: productProvider.isLoading,
                  errorMessage: productProvider.errorMessage,
                ),

                const SizedBox(height: 24),

                // ====================== BEST SELLERS ======================
                _SectionTitle(
                  title: 'best_sellers'.tr(context),
                  textTheme: textTheme,
                  actionText: 'see_all'.tr(context),
                  onActionTap: () {},
                ),
                const SizedBox(height: 12),
                _ProductList(
                  products: productProvider.bestSellers,
                  isLoading: productProvider.isLoading,
                  errorMessage: productProvider.errorMessage,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ====================== HEADER ======================
  Widget _buildHeader(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary, width: 2),
            ),
            child: Image.network(
              'https://i.pravatar.cc/150?img=12',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: colors.primaryContainer,
                child: Icon(
                  Icons.person_outline,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Heng Ousa',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'welcome_back'.tr(context),
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.bell, color: colors.onSurface),
          ),
          IconButton(
            onPressed: () {
              // TODO: Go to CartScreen
            },
            icon: Icon(CupertinoIcons.shopping_cart, color: colors.onSurface),
          ),
        ],
      ),
    );
  }

  // ====================== SEARCH ======================
  Widget _buildSearchBar(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {},
                child: SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.search,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'search_products_brands'.tr(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: colors.primary,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {},
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.tune_rounded, color: colors.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== SECTION TITLE ======================
class _SectionTitle extends StatelessWidget {
  final String title;
  final TextTheme textTheme;
  final String? actionText;
  final VoidCallback? onActionTap;

  const _SectionTitle({
    required this.title,
    required this.textTheme,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (actionText != null)
            TextButton(onPressed: onActionTap, child: Text(actionText!)),
        ],
      ),
    );
  }
}

// ====================== PRODUCT LIST (REAL DATA) ======================
class _ProductList extends StatelessWidget {
  final List<ProductModel> products;
  final bool isLoading;
  final String? errorMessage;

  const _ProductList({
    required this.products,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isLoading) {
      return const SizedBox(
        height: 290,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(errorMessage!, style: TextStyle(color: colors.error)),
        ),
      );
    }

    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'no_products'.tr(context),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      );
    }

    return SizedBox(
      height: 290,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            onFavoriteTap: () {
              // TODO: Toggle favorite
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
