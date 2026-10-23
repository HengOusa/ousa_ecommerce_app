import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SplashDestination { onboarding, login, layout }

class SplashProvider extends ChangeNotifier {
  static const String onboardingKey = 'onboarding_completed';
  static const Duration splashDuration = Duration(seconds: 2);

  Future<SplashDestination>? _startupFuture;

  Future<SplashDestination> checkStartupState() {
    return _startupFuture ??= _resolveStartupState();
  }

  Future<SplashDestination> _resolveStartupState() async {
    await Future<void>.delayed(splashDuration);

    try {
      final preferences = await SharedPreferences.getInstance();

      final onboardingCompleted = preferences.getBool(onboardingKey) ?? false;

      final session = Supabase.instance.client.auth.currentSession;

      if (session != null) {
        return SplashDestination.layout;
      }

      if (!onboardingCompleted) {
        return SplashDestination.onboarding;
      }

      return SplashDestination.login;
    } catch (error, stackTrace) {
      debugPrint('Startup check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return SplashDestination.login;
    }
  }

  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(onboardingKey, true);
  }

  void resetStartupCheck() {
    _startupFuture = null;
  }
}
