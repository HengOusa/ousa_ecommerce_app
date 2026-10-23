import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

enum LayoutNavigationType { mobile, tablet, desktop }

class LayoutNavigation extends StatelessWidget {
  final int selectedIndex;
  final int cartCount;
  final ValueChanged<int> onDestinationSelected;
  final LayoutNavigationType type;

  const LayoutNavigation({
    super.key,
    required this.selectedIndex,
    required this.cartCount,
    required this.onDestinationSelected,
    required this.type,
  });

  static const List<String> _labels = [
    'Home',
    'Cart',
    'Search',
    'Wishlist',
    'Profile',
  ];

  static const List<HeroIcons> _icons = [
    HeroIcons.home,
    HeroIcons.shoppingCart,
    HeroIcons.magnifyingGlassCircle,
    HeroIcons.heart,
    HeroIcons.user,
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex.clamp(0, _labels.length - 1);

    switch (type) {
      case LayoutNavigationType.mobile:
        return _buildMobile(context, safeIndex);

      case LayoutNavigationType.tablet:
        return _buildRail(context, extended: false);

      case LayoutNavigationType.desktop:
        return _buildRail(context, extended: true);
    }
  }

  // ============================================================
  // MOBILE: TELEGRAM-INSPIRED FLOATING GLASS NAVIGATION
  // ============================================================

  Widget _buildMobile(BuildContext context, int activeIndex) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.76),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.45),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.08),
                blurRadius: 26,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.035),
                blurRadius: 16,
                spreadRadius: -2,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / _labels.length;

              return Stack(
                children: [
                  // Sliding glass selection indicator.
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutBack,
                    left: itemWidth * activeIndex + 4,
                    top: 5,
                    bottom: 5,
                    width: itemWidth - 8,
                    child: _ActiveGlassIndicator(),
                  ),

                  // Navigation destinations.
                  Row(
                    children: List.generate(
                      _labels.length,
                      (index) => Expanded(
                        child: _MobileDestination(
                          label: _labels[index],
                          icon: _icons[index],
                          active: activeIndex == index,
                          cartCount: index == 1 ? cartCount : 0,
                          onTap: () => onDestinationSelected(index),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABLET AND DESKTOP SIDEBAR
  // ============================================================

  Widget _buildRail(BuildContext context, {required bool extended}) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: extended ? 240 : 84,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.94),
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: extended ? 18 : 10,
                vertical: 22,
              ),
              child: Row(
                mainAxisAlignment: extended
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: colors.primary,
                      size: 25,
                    ),
                  ),
                  if (extended) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Shopiza',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Divider(
              height: 1,
              indent: 14,
              endIndent: 14,
              color: colors.outlineVariant.withValues(alpha: 0.5),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: extended ? 12 : 8),
                itemCount: _labels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final active = selectedIndex == index;

                  return _RailDestination(
                    label: _labels[index],
                    icon: _icons[index],
                    active: active,
                    extended: extended,
                    cartCount: index == 1 ? cartCount : 0,
                    onTap: () => onDestinationSelected(index),
                  );
                },
              ),
            ),

            if (extended)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: colors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Shop smarter with Shopiza',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATED GLASS INDICATOR
// ============================================================

class _ActiveGlassIndicator extends StatelessWidget {
  const _ActiveGlassIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.08),
                blurRadius: 14,
                spreadRadius: -2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MOBILE DESTINATION WITH ICON SCALE AND FADE ANIMATION
// ============================================================

class _MobileDestination extends StatelessWidget {
  final String label;
  final HeroIcons icon;
  final bool active;
  final int cartCount;
  final VoidCallback onTap;

  const _MobileDestination({
    required this.label,
    required this.icon,
    required this.active,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: active ? 1.10 : 1.0,
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.all(5),
                          child: HeroIcon(
                            icon,
                            style: active
                                ? HeroIconStyle.solid
                                : HeroIconStyle.outline,
                            size: 23,
                            color: active
                                ? colors.primary
                                : colors.onSurfaceVariant,
                          ),
                        ),

                        if (cartCount > 0)
                          Positioned(
                            top: -3,
                            right: -6,
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 17,
                                minHeight: 17,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.error,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colors.surface,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                cartCount > 99 ? '99+' : '$cartCount',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onError,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3),

                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: active ? colors.primary : colors.onSurfaceVariant,
                      fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                      fontSize: active ? 10.5 : 10,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Telegram-inspired active dot.
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    width: active ? 12 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TABLET / DESKTOP DESTINATION
// ============================================================

class _RailDestination extends StatelessWidget {
  final String label;
  final HeroIcons icon;
  final bool active;
  final bool extended;
  final int cartCount;
  final VoidCallback onTap;

  const _RailDestination({
    required this.label,
    required this.icon,
    required this.active,
    required this.extended,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Tooltip(
      message: extended ? '' : label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: extended ? 12 : 0,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: active
                  ? colors.primary.withValues(alpha: 0.11)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active
                    ? colors.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: extended
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: active ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child: HeroIcon(
                    icon,
                    style: active ? HeroIconStyle.solid : HeroIconStyle.outline,
                    size: 23,
                    color: active ? colors.primary : colors.onSurfaceVariant,
                  ),
                ),

                if (extended) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: active
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      ),
                      child: Text(label),
                    ),
                  ),

                  if (cartCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cartCount > 99 ? '99+' : '$cartCount',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onError,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
