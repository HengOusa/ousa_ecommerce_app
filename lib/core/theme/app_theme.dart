import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

abstract final class AppTheme {
  static ThemeData light(String languageCode) => LightTheme.theme(languageCode);

  static ThemeData dark(String languageCode) => DarkTheme.theme(languageCode);
}
