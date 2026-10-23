
import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/features/splash/presentation/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<SplashDestination> _startupFuture;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Safe here because the provider does not notify listeners
    // while starting its asynchronous check.
    _startupFuture =
        context.read<SplashProvider>().checkStartupState();
  }

  void _navigate(SplashDestination destination) {
    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;

    switch (destination) {
      case SplashDestination.onboarding:
        context.go(AppRoutes.onboarding);
        break;

      case SplashDestination.login:
        context.go(AppRoutes.login);
        break;

      case SplashDestination.layout:
        context.go(AppRoutes.layout);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FutureBuilder<SplashDestination>(
      future: _startupFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final destination = snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _navigate(destination);
          });
        }

        return Scaffold(
          backgroundColor: colors.surface,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 600;

                return Stack(
                  children: [
                    Positioned(
                      top: -90,
                      right: -80,
                      child: _Circle(
                        size: 240,
                        color: colors.primary.withOpacity(0.07),
                      ),
                    ),
                    Positioned(
                      bottom: -110,
                      left: -90,
                      child: _Circle(
                        size: 260,
                        color: colors.secondary.withOpacity(0.06),
                      ),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 440),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            children: [
                              const Spacer(flex: 3),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.8, end: 1),
                                duration:
                                    const Duration(milliseconds: 800),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: compact ? 86 : 108,
                                      height: compact ? 86 : 108,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: colors.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.primary
                                                .withOpacity(0.12),
                                            blurRadius: 24,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/logo/logo.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.shopping_bag_rounded,
                                            size: 54,
                                            color:
                                                colors.onPrimaryContainer,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 22),
                                    Text(
                                      'Shopiza',
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(
                                        fontSize: compact ? 32 : 38,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -1,
                                        color: colors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Discover more. Shop smarter.',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(flex: 3),
                              Container(
                                width: 42,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: colors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'MADE FOR YOUR EVERYDAY SHOPPING',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
