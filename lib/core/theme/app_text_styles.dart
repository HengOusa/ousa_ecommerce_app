import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  AppTextStyles._();

  /// Returns the application's TextTheme based on the language.
  /// English  ->.poppins
  /// Khmer    -> Noto Sans Khmer
  static TextTheme textTheme(String languageCode) {
    final isKhmer = languageCode == 'km';
    return TextTheme(
      // DISPLAY
      displayLarge: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.5,
            )
          : GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.5,
            ),

      displayMedium: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.4,
            )
          : GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.4,
            ),

      displaySmall: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.25,
            )
          : GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
      // HEADLINES
      headlineLarge: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.25,
            )
          : GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),

      headlineMedium: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            )
          : GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),

      headlineSmall: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            )
          : GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
      // TITLES
      titleLarge: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.3,
            )
          : GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),

      titleMedium: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.35,
            )
          : GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),

      titleSmall: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            )
          : GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
      // BODY
      bodyLarge: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            )
          : GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),

      bodyMedium: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            )
          : GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),

      bodySmall: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.45,
            )
          : GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
      // LABELS
      labelLarge: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            )
          : GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),

      labelMedium: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.35,
            )
          : GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),

      labelSmall: isKhmer
          ? GoogleFonts.battambang(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
            )
          : GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
    );
  }
}
