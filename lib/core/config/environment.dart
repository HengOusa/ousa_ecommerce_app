abstract final class Environment {
  static const String appName = 'OuSa';

  static const String url = 'https://iztsqdvqwdbansjqquak.supabase.co';

  static const String publishableKey =
      'sb_publishable_00vfjq5U_sEq7y2PsCtOqg_yRg24zR1';

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
