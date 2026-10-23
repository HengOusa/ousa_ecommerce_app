
import 'package:ecom_app/app/routes/app_router.dart';
import 'package:ecom_app/core/network/network_notification_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/localization/app_locales.dart';
import 'core/services/localization_provider.dart';
import 'core/services/theme_provider.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = context.watch<LocalizationProvider>();
    final themeService = context.watch<ThemeService>();

    return MaterialApp.router(
      title: 'Shopiza',
      debugShowCheckedModeBanner: false,

      // Global SnackBar support.
      scaffoldMessengerKey: appScaffoldMessengerKey,

      // Global network notifications for every route.
      builder: (context, child) {
        return NetworkNotificationListener(
          child: child ?? const SizedBox.shrink(),
        );
      },

      // Localization.
      locale: localization.locale,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Theme.
      theme: AppTheme.light(localization.locale.languageCode),
      darkTheme: AppTheme.dark(localization.locale.languageCode),
      themeMode: themeService.themeMode,
      // Navigation.
      routerConfig: appRouter,
    );
  }
}
