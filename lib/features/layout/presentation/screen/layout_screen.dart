
import 'package:ecom_app/features/layout/presentation/layouts/desktop_layout.dart';
import 'package:ecom_app/features/layout/presentation/layouts/mobile_layout.dart';
import 'package:ecom_app/features/layout/presentation/layouts/tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecom_app/core/responsive/responsive_builder.dart';
import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecom_app/features/cart/presentation/screen/cart_screen.dart';
import 'package:ecom_app/features/home/presentation/screen/home_screen.dart';
import 'package:ecom_app/features/layout/presentation/providers/layout_provider.dart';
import 'package:ecom_app/features/profile/presentation/screen/profile_screen.dart';
import 'package:ecom_app/features/search/presentation/screen/search_screen.dart';
import 'package:ecom_app/features/wishlist/presentation/screen/wishlist_screen.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutProvider = context.watch<LayoutProvider>();
    final cartProvider = context.watch<CartProvider>();

    final tabs = [
      const HomeScreen(),
      const CartScreen(),
      const SearchScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];

    final index =
        layoutProvider.currentIndex.clamp(0, tabs.length - 1);

    final body = IndexedStack(
      index: index,
      children: tabs,
    );

    return ResponsiveBuilder(
      mobile: MobileHomeLayout(
        body: body,
        selectedIndex: index,
        cartCount: cartProvider.cartItems.length,
        onDestinationSelected: layoutProvider.changePage,
      ),
      tablet: TabletHomeLayout(
        body: body,
        selectedIndex: index,
        cartCount: cartProvider.cartItems.length,
        onDestinationSelected: layoutProvider.changePage,
      ),
      desktop: DesktopHomeLayout(
        body: body,
        selectedIndex: index,
        cartCount: cartProvider.cartItems.length,
        onDestinationSelected: layoutProvider.changePage,
      ),
    );
  }
}
