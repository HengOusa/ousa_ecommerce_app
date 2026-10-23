import 'package:ecom_app/app.dart';
import 'package:ecom_app/app/di/injection.dart';
import 'package:ecom_app/app/providers/app_providers.dart';
import 'package:ecom_app/core/config/environment.dart';
import 'package:ecom_app/core/network/network_service.dart';
import 'package:ecom_app/core/persistence/preferences_service.dart';
import 'package:ecom_app/core/services/localization_provider.dart';
import 'package:ecom_app/core/services/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  final preferences = PreferencesService(sharedPreferences);

  // 2. Core services
  final localizationProvider = LocalizationProvider(preferences);
  final themeService = ThemeService(preferences);
  // 6. Network service
  final networkService = NetworkService();

  // 3. Environment check
  if (!Environment.isConfigured) {
    throw StateError(
      'Please configure SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY in Environment.',
    );
  }

  // 4. Initialize Supabase
  await Supabase.initialize(
    url: Environment.url,
    publishableKey: Environment.publishableKey,
  );

  // 5. Initialize all repositories
  Injection.init();

  // await networkService.initialize();

  // 7. Initialize theme & localization
  await Future.wait([
    localizationProvider.init(),
    themeService.init(),
    networkService.initialize(),
  ]);

  // 8. Run the app
  runApp(
    MultiProvider(
      providers: AppProviders.providers(
        localizationProvider: localizationProvider,
        themeService: themeService,
        networkService: networkService,
      ),
      child: const App(),
    ),
  );
}
