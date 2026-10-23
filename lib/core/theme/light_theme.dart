import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract class LightTheme {
  LightTheme._();
  // LIGHT COLOR SCHEME
  static const colorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    primaryContainer: Color(0xFFDDF7DE),
    onPrimaryContainer: Color(0xFF063A08),

    // Secondary
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFE0B2),
    onSecondaryContainer: Color(0xFF4A2800),

    // Tertiary
    tertiary: AppColors.accent,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD9ECFF),
    onTertiaryContainer: Color(0xFF003258),

    // Error
    error: AppColors.error,
    onError: Colors.white,
    errorContainer: AppColors.errorLight,
    onErrorContainer: Color(0xFF410002),

    // Surface
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,

    // Surface Variant
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.textSecondary,

    // Outline
    outline: AppColors.border,
    outlineVariant: AppColors.borderLight,

    // Shadow / Scrim
    shadow: Colors.black,
    scrim: Colors.black,
  );

  // LIGHT THEME
  static ThemeData theme(String languageCode) {
    return ThemeData(
      useMaterial3: true,
      // COLOR
      colorScheme: colorScheme,
      // TYPOGRAPHY
      textTheme: AppTextStyles.textTheme(languageCode),
      // SCAFFOLD
      scaffoldBackgroundColor: AppColors.background,
      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.textTheme(
          languageCode,
        ).titleLarge?.copyWith(color: colorScheme.onSurface),
      ),

      // DIVIDER
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),

      // CARD
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // INPUT
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        labelStyle: AppTextStyles.textTheme(languageCode).bodyMedium,
        hintStyle: AppTextStyles.textTheme(
          languageCode,
        ).bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        errorStyle: AppTextStyles.textTheme(
          languageCode,
        ).bodySmall?.copyWith(color: colorScheme.error),
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
          textStyle: AppTextStyles.textTheme(languageCode).labelLarge,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
