import 'package:ecom_app/core/constrants/storage_constants.dart';
import 'package:flutter/material.dart';

import '../persistence/preferences_service.dart';

class ThemeService extends ChangeNotifier {
  final PreferencesService _preferences;

  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeService(this._preferences);

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  Future<void> init() async {
    final value = _preferences.getString(StorageConstants.themeMode);
    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    await _preferences.setString(StorageConstants.themeMode, mode.name);
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> setLight() => setTheme(ThemeMode.light);
  Future<void> setDark() => setTheme(ThemeMode.dark);
  Future<void> setSystem() => setTheme(ThemeMode.system);

  Future<void> toggleTheme() =>
      setTheme(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}
