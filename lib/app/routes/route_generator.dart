import 'package:ecom_app/app/routes/app_routes.dart';
import 'package:ecom_app/features/auth/presentation/screen/login_screen.dart';
import 'package:ecom_app/features/auth/presentation/screen/signup_screen.dart';
import 'package:ecom_app/features/count.dart';
import 'package:ecom_app/features/home/presentation/screen/home_screen.dart';
import 'package:ecom_app/features/layout/presentation/screen/layout_screen.dart';
import 'package:ecom_app/features/onboarding/presentation/screen/onboarding_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRoutes.layout:
        return MaterialPageRoute(builder: (_) => const LayoutScreen());
      case AppRoutes.cout:
        return MaterialPageRoute(builder: (_) => const Count());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
