// lib/core/validation/validation_messages.dart

class ValidationMessages {
  ValidationMessages._();

  static const String required = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordNotMatch = 'Passwords do not match';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidPrice = 'Please enter a valid price';
  static const String invalidStock = 'Please enter a valid stock quantity';

  static String passwordTooShort(int min) =>
      'Password must be at least $min characters';

  static String nameTooShort(int min) =>
      'Name must be at least $min characters';

  static String fieldRequired(String field) => '$field is required';
}
