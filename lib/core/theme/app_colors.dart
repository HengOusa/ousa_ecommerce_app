import 'package:flutter/animation.dart';

abstract class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF10AF15);
  static const primaryDark = Color(0xFF0B8F10);
  static const primaryLight = Color(0xFF43C947);

  // SECONDARY
  static const secondary = Color(0xFFFF9800);
  static const secondaryDark = Color(0xFFE68900);
  static const secondaryLight = Color(0xFFFFB74D);

  // TERTIARY
  static const tertiary = Color(0xFF2196F3);

  // ACCENT
  static const accent = Color(0xFF2196F3);

  // BACKGROUND
  static const background = Color(0xFFF8F9FA);
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F3F5);

  // TEXT
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);
  static const textDisabled = Color(0xFFBDBDBD);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // BORDER / DIVIDER
  static const border = Color(0xFFE0E0E0);
  static const borderLight = Color(0xFFEEEEEE);
  static const divider = Color(0xFFE5E5E5);

  // STATUS
  static const success = Color(0xFF2E7D32);
  static const successLight = Color(0xFFE8F5E9);
  static const warning = Color(0xFFF9A825);
  static const warningLight = Color(0xFFFFF8E1);
  static const error = Color(0xFFD32F2F);
  static const errorLight = Color(0xFFFFEBEE);
  static const info = Color(0xFF1976D2);
  static const infoLight = Color(0xFFE3F2FD);
  // E-COMMERCE
  static const sale = Color(0xFFE53935);
  static const discount = Color(0xFFE53935);
  static const price = Color(0xFF10AF15);
  static const rating = Color(0xFFFFB300);
  static const stockAvailable = Color(0xFF2E7D32);
  static const stockOut = Color(0xFFD32F2F);
  // OVERLAY
  static const overlay = Color(0x66000000);
  static const overlayLight = Color(0x33000000);
}
