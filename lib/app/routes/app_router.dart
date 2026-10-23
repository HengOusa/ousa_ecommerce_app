import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/features/auth/presentation/screen/login_screen.dart';
import 'package:ecom_app/features/auth/presentation/screen/signup_screen.dart';
import 'package:ecom_app/features/home/presentation/screen/home_screen.dart';
import 'package:ecom_app/features/layout/presentation/screen/layout_screen.dart';
import 'package:ecom_app/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:ecom_app/features/settings/presentations/settings_screen.dart';
import 'package:ecom_app/features/splash/presentation/screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.layout,
      name: AppRoutes.layout,
      builder: (context, state) => const LayoutScreen(),
    ),
  ],
);
