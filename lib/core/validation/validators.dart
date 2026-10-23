// lib/core/validation/validators.dart

import 'package:ecom_app/core/validation/validation_messages.dart';

class Validators {
  Validators._();

  // ── Email ──────────────────────────────────────────────
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.required;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return ValidationMessages.invalidEmail;
    }

    return null;
  }

  // ── Password ───────────────────────────────────────────
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.required;
    }

    if (value.length < minLength) {
      return ValidationMessages.passwordTooShort(minLength);
    }

    // Optional: stronger password rules
    // if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain uppercase';
    // if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain number';

    return null;
  }

  // ── Confirm Password ───────────────────────────────────
  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.required;
    }

    if (value != originalPassword) {
      return ValidationMessages.passwordNotMatch;
    }

    return null;
  }

  // ── Name / Full Name ───────────────────────────────────
  static String? name(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.required;
    }

    if (value.trim().length < minLength) {
      return ValidationMessages.nameTooShort(minLength);
    }

    return null;
  }

  // ── Phone Number (Cambodia friendly) ───────────────────
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.required;
    }

    // Accept: 012345678, 012 345 678, +85512345678, etc.
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneRegex = RegExp(r'^(\+855|0)?[1-9]\d{7,8}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return ValidationMessages.invalidPhone;
    }

    return null;
  }

  // ── Required (generic) ─────────────────────────────────
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? ValidationMessages.fieldRequired(fieldName)
          : ValidationMessages.required;
    }
    return null;
  }

  // ── Price / Amount ─────────────────────────────────────
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.required;
    }

    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return ValidationMessages.invalidPrice;
    }

    return null;
  }

  // ── Stock Quantity ─────────────────────────────────────
  static String? stock(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationMessages.required;
    }

    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return ValidationMessages.invalidStock;
    }

    return null;
  }
}
