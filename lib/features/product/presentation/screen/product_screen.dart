// lib/features/product/presentation/screens/product_screen.dart

import 'package:ecom_app/features/product/presentation/providers/product_provider.dart';
import 'package:ecom_app/features/product/presentation/widgets/product_card.dart';
import 'package:ecom_app/features/product/presentation/widgets/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.loadProducts(),
        child: Builder(
          builder: (context) {
            if (productProvider.isLoading && productProvider.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (productProvider.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(productProvider.errorMessage ?? 'Something went wrong'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => productProvider.loadProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (productProvider.products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];

                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  onFavoriteTap: () {
                    // TODO: toggle favorite
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}