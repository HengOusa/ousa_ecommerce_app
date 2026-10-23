import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/localization_provider.dart';
import 'app_translations.dart';

extension TranslateExtension on String {
  String tr(BuildContext context) {
    final locale = context.watch<LocalizationProvider>().locale;
    return AppTranslations.translate(
      this,
      locale.languageCode,
      locale.countryCode,
    );
  }
}
