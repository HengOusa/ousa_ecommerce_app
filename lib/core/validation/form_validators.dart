// lib/core/validation/form_validators.dart

import 'package:flutter/material.dart';
import 'validators.dart';

class FormValidators {
  FormValidators._();

  static FormFieldValidator<String> email = (value) => Validators.email(value);

  static FormFieldValidator<String> password = (value) =>
      Validators.password(value);

  static FormFieldValidator<String> name = (value) => Validators.name(value);

  static FormFieldValidator<String> phone = (value) => Validators.phone(value);

  static FormFieldValidator<String> required([String? fieldName]) =>
      (value) => Validators.required(value, fieldName);

  // Confirm password needs the original password
  static FormFieldValidator<String> confirmPassword(String original) {
    return (value) => Validators.confirmPassword(value, original);
  }
}
