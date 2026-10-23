import 'package:ecom_app/app/di/injection.dart';
import 'package:ecom_app/core/network/network_service.dart';
import 'package:ecom_app/core/services/localization_provider.dart';
import 'package:ecom_app/core/services/theme_provider.dart';
import 'package:ecom_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecom_app/features/auth/presentation/providers/login_provider.dart';
import 'package:ecom_app/features/auth/presentation/providers/signup_provider.dart';
import 'package:ecom_app/features/cart/data/repositories/cart_repository.dart';
import 'package:ecom_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:ecom_app/features/home/presentation/providers/home_provider.dart';
import 'package:ecom_app/features/layout/presentation/providers/layout_provider.dart';
import 'package:ecom_app/features/onboarding/data/onboarding_data.dart';
import 'package:ecom_app/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:ecom_app/features/product/data/repositories/product_repository.dart';
import 'package:ecom_app/features/product/presentation/providers/product_provider.dart';
import 'package:ecom_app/features/splash/presentation/providers/splash_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class FeatureProviders {
  FeatureProviders._();

  static List<SingleChildWidget> providers({
    required LocalizationProvider localizationProvider,
    required ThemeService themeService,
    required NetworkService networkService,
  }) {
    return [
      // ===== CORE =====
      Provider.value(value: networkService),
      ChangeNotifierProvider.value(value: localizationProvider),
      ChangeNotifierProvider.value(value: themeService),

      // ===== AUTH =====
      ChangeNotifierProvider(
        create: (_) => AuthProvider(Injection.authRepository),
      ),
      ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),
      ChangeNotifierProxyProvider<AuthProvider, LoginProvider>(
        create: (context) => LoginProvider(context.read<AuthProvider>()),
        update: (_, auth, previous) => previous ?? LoginProvider(auth),
      ),
      ChangeNotifierProxyProvider<AuthProvider, SignupProvider>(
        create: (context) => SignupProvider(context.read<AuthProvider>()),
        update: (_, auth, previous) => previous ?? SignupProvider(auth),
      ),

      // ===== PRODUCT =====
      ChangeNotifierProvider(
        create: (context) =>
            ProductProvider(context.read<ProductRepository>())
              ..loadInitialData(),
      ),

      // ===== CART =====
      ChangeNotifierProvider(
        create: (context) => CartProvider(
          context.read<CartRepository>(),
          context.read<AuthProvider>(),
        )..loadCart(),
      ),

      // ===== OTHERS =====
      ChangeNotifierProvider(create: (_) => LayoutProvider()),
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      ChangeNotifierProvider(
        create: (_) =>
            OnboardingProvider(totalPages: OnboardingData.items.length),
      ),

      ChangeNotifierProvider<SplashProvider>(create: (_) => SplashProvider()),
    ];
  }
}
