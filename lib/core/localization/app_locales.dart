import 'package:flutter/material.dart';

class AppLocales {
  AppLocales._();

  static const Locale english = Locale('en', 'US');
  static const Locale khmer = Locale('km', 'KH');

  static const Locale defaultLocale = english;

  static const List<Locale> supported = [english, khmer];
}
