import 'package:ecom_app/features/layout/presentation/providers/layout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../widgets/layout_navigation.dart';

class MobileHomeLayout extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onDestinationSelected;

  const MobileHomeLayout({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.cartCount,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final layoutProvider = context.watch<LayoutProvider>();
    return Scaffold(
      // Let content extend behind the floating navigation.
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification.direction != ScrollDirection.idle) {
            layoutProvider.handleScrollDirection(notification.direction);
          }

          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main page fills the screen.
            body,

            // Floating navigation overlay.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IgnorePointer(
                    ignoring: !layoutProvider.isBottomNavVisible,
                    child: ClipRect(
                      child: AnimatedSlide(
                        offset: layoutProvider.isBottomNavVisible
                            ? Offset.zero
                            : const Offset(0, 1.3),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        child: AnimatedOpacity(
                          opacity: layoutProvider.isBottomNavVisible ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: LayoutNavigation(
                            selectedIndex: selectedIndex,
                            cartCount: cartCount,
                            onDestinationSelected: onDestinationSelected,
                            type: LayoutNavigationType.mobile,
                          ),
                        ),
                      ),
                    ),
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
