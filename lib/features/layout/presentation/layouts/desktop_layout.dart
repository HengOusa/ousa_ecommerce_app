import 'package:flutter/material.dart';

import '../widgets/layout_navigation.dart';

class DesktopHomeLayout extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onDestinationSelected;

  const DesktopHomeLayout({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.cartCount,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LayoutNavigation(
            type: LayoutNavigationType.desktop,
            selectedIndex: selectedIndex,
            cartCount: cartCount,
            onDestinationSelected: onDestinationSelected,
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
