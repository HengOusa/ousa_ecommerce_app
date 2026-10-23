import 'package:flutter/material.dart';

import 'app_text_styles.dart';

abstract class DarkTheme {
  DarkTheme._();

  // ============================================================
  // DARK COLOR SCHEME
  // ============================================================

  static const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primary
    primary: Color(0xFF72DA76),
    onPrimary: Color(0xFF003907),
    primaryContainer: Color(0xFF07530C),
    onPrimaryContainer: Color(0xFFA0F5A3),

    // Secondary
    secondary: Color(0xFFFFB74D),
    onSecondary: Color(0xFF452A00),
    secondaryContainer: Color(0xFF634000),
    onSecondaryContainer: Color(0xFFFFDDB5),

    // Tertiary
    tertiary: Color(0xFF90CAFF),
    onTertiary: Color(0xFF003354),
    tertiaryContainer: Color(0xFF004A76),
    onTertiaryContainer: Color(0xFFC9E6FF),

    // Error
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),

    // Surface
    surface: Color(0xFF101410),
    onSurface: Color(0xFFE1E3DE),

    // Surface Variant
    surfaceContainerHighest: Color(0xFF424842),
    onSurfaceVariant: Color(0xFFC1C9BD),

    // Outline
    outline: Color(0xFF8B9389),
    outlineVariant: Color(0xFF424842),

    // Shadow / Scrim
    shadow: Colors.black,
    scrim: Colors.black,
  );
  // DARK THEME
  static ThemeData theme(String languageCode) {
    final textTheme = AppTextStyles.textTheme(languageCode).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      // COLOR
      colorScheme: colorScheme,
      // TYPOGRAPHY
      textTheme: AppTextStyles.textTheme(languageCode),
      // SCAFFOLD
      scaffoldBackgroundColor: colorScheme.surface,
      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      // DIVIDER
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      // CARD
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,

        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),

        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),

        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      // ELEVATED BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
