import 'package:ecom_app/core/constrants/storage_constants.dart';
import 'package:flutter/material.dart';
import '../localization/app_locales.dart';
import '../persistence/preferences_service.dart';

class LocalizationProvider extends ChangeNotifier {
  final PreferencesService _preferences;

  Locale _locale = AppLocales.defaultLocale;
  bool _isInitialized = false;

  LocalizationProvider(this._preferences);

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isKhmer => _locale.languageCode == 'km';

  String get currentLanguageName => isKhmer ? 'ភាសាខ្មែរ' : 'English';

  Future<void> init() async {
    final savedLanguage = _preferences.getString(StorageConstants.language);
    final savedLocale = savedLanguage == null
        ? null
        : localeFromString(savedLanguage);

    _locale = savedLocale ?? AppLocales.defaultLocale;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (!isSupported(newLocale) || newLocale == _locale) return;

    await _preferences.setString(
      StorageConstants.language,
      localeToString(newLocale),
    );

    _locale = newLocale;
    notifyListeners();
  }

  Future<void> setEnglish() => changeLanguage(AppLocales.english);
  Future<void> setKhmer() => changeLanguage(AppLocales.khmer);

  Future<void> toggleLanguage() =>
      changeLanguage(isEnglish ? AppLocales.khmer : AppLocales.english);

  bool isSupported(Locale value) => AppLocales.supported.any(
    (locale) =>
        locale.languageCode == value.languageCode &&
        locale.countryCode == value.countryCode,
  );

  String localeToString(Locale value) =>
      '${value.languageCode}_${value.countryCode}';

  Locale? localeFromString(String value) {
    for (final locale in AppLocales.supported) {
      if (localeToString(locale) == value) return locale;
    }
    return null;
  }
}
