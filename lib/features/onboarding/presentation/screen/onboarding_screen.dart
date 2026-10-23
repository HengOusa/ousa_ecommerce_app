import 'dart:ui';
import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/core/constrants/app_strings.dart';
import 'package:ecom_app/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:ecom_app/features/onboarding/presentation/widgets/onboarding_item.dart';
import 'package:ecom_app/features/splash/presentation/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OnboardingProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF101827) : const Color(0xFFF0F5F2),
      body: Stack(
        children: [
          // GLASSMORPHISM BACKGROUND
          const Positioned.fill(child: _OnboardingBackground()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                children: [
                  // TOP BAR
                  Row(
                    children: [
                      // BRAND
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: colors.primary,
                              size: 23,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'SHOPIZA',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // GLASS SKIP BUTTON
                      _GlassSkipButton(dark: dark, onPressed: provider.skip),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ONBOARDING CONTENT
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: _GlassContentCard(
                          dark: dark,
                          child: PageView.builder(
                            controller: provider.pageController,
                            itemCount: provider.onboardingItems.length,
                            onPageChanged: provider.onPageChanged,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: OnboardingItem(
                                  item: provider.onboardingItems[index],
                                  imageHeight: 190,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // GLASS PAGE INDICATORS
                  _GlassPageIndicator(
                    currentPage: provider.currentPage,
                    itemCount: provider.onboardingItems.length,
                    dark: dark,
                  ),

                  const SizedBox(height: 22),

                  // PAGE COUNTER
                  Text(
                    '${provider.currentPage + 1} / '
                    '${provider.onboardingItems.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // NEXT / GET STARTED BUTTON
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: _GlassPrimaryButton(
                        title: provider.isLastPage
                            ? 'Get Started'
                            : AppStrings.next,
                        onPressed: () async {
                          final isFinished = await provider.nextPage();

                          if (!context.mounted) return;

                          if (isFinished) {
                            await context
                                .read<SplashProvider>()
                                .completeOnboarding();

                            if (!context.mounted) return;

                            context.go(AppRoutes.login);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BACKGROUND WITH BLURRED GRADIENT CIRCLES
// ============================================================

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: _GlowCircle(
            size: 300,
            color: dark ? const Color(0xFF087F5B) : const Color(0xFF71D9A0),
          ),
        ),
        Positioned(
          top: 200,
          right: -120,
          child: _GlowCircle(
            size: 280,
            color: dark ? const Color(0xFF234D8C) : const Color(0xFF9BC8F8),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -60,
          child: _GlowCircle(
            size: 300,
            color: dark ? const Color(0xFF155E75) : const Color(0xFFA4E6D2),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 65, sigmaY: 65),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.75),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ============================================================
// GLASS CONTENT CARD
// ============================================================

class _GlassContentCard extends StatelessWidget {
  const _GlassContentCard({required this.child, required this.dark});

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: dark
                ? const Color(0xFF182438).withValues(alpha: 0.72)
                : Colors.white.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.85),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.15 : 0.045),
                blurRadius: 35,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassSkipButton extends StatelessWidget {
  const _GlassSkipButton({required this.dark, required this.onPressed});

  final bool dark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: dark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.white.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.8),
            ),
          ),
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              foregroundColor: colors.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Skip', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_rounded, size: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ANIMATED GLASS PAGE INDICATOR
// ============================================================

class _GlassPageIndicator extends StatelessWidget {
  const _GlassPageIndicator({
    required this.currentPage,
    required this.itemCount,
    required this.dark,
  });

  final int currentPage;
  final int itemCount;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: dark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(itemCount, (index) {
              final isActive = currentPage == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.primary
                      : colors.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// GLASS PRIMARY BUTTON
// ============================================================

class _GlassPrimaryButton extends StatelessWidget {
  const _GlassPrimaryButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [primary, Color.lerp(primary, Colors.black, 0.18)!],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, size: 21),
          ],
        ),
      ),
    );
  }
}
