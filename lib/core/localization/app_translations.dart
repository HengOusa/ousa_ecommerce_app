import 'en_us.dart';
import 'km_kh.dart';

abstract final class AppTranslations {
  static const Map<String, Map<String, String>> translations = {
    'en_US': enUS,
    'km_KH': kmKH,
  };

  static String translate(
    String key,
    String languageCode,
    String? countryCode,
  ) {
    final localeKey =
        countryCode == null ? languageCode : '${languageCode}_$countryCode';

    return translations[localeKey]?[key] ??
        translations['en_US']?[key] ??
        key;
  }
}
