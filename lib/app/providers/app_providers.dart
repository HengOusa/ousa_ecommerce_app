import 'package:ecom_app/app/providers/feature_providers.dart';
import 'package:ecom_app/app/providers/repository_providers.dart';
import 'package:ecom_app/core/network/network_service.dart';
import 'package:ecom_app/core/services/localization_provider.dart';
import 'package:ecom_app/core/services/theme_provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  AppProviders._();

  static List<SingleChildWidget> providers({
    required LocalizationProvider localizationProvider,
    required ThemeService themeService,
    required NetworkService networkService,
  }) {
    return [
      // 1. Repositories first
      ...RepositoryProviders.providers,

      // 2. Feature providers
      ...FeatureProviders.providers(
        localizationProvider: localizationProvider,
        themeService: themeService,
        networkService: networkService,
      ),
    ];
  }
}
