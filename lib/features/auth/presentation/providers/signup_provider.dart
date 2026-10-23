import 'package:flutter/material.dart';

import 'package:ecom_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecom_app/features/auth/presentation/validators/signup_validator.dart';

class SignupProvider extends ChangeNotifier {
  SignupProvider(this._authProvider);

  final AuthProvider _authProvider;
  final SignupValidator _validator = SignupValidator();

  // Form and text controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordConfirmationController =
      TextEditingController();

  // UI state
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isPasswordConfirmationVisible => _isPasswordConfirmationVisible;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Supabase signup may succeed without an active session
  // when email confirmation is enabled.
  bool get requiresEmailConfirmation => !_authProvider.hasActiveSession;

  // ----------------------------------------------------------
  // PASSWORD VISIBILITY
  // ----------------------------------------------------------

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isPasswordConfirmationVisible = !_isPasswordConfirmationVisible;
    notifyListeners();
  }

  // ----------------------------------------------------------
  // VALIDATION
  // ----------------------------------------------------------

  String? validateName(String? value) => _validator.validateName(value);

  String? validateEmail(String? value) => _validator.validateEmail(value);

  String? validatePassword(String? value) => _validator.validatePassword(value);

  String? validatePasswordConfirmation(String? value) =>
      _validator.validatePasswordConfirmation(value, passwordController.text);

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // ----------------------------------------------------------
  // SIGN UP
  // ----------------------------------------------------------

  Future<bool> signup() async {
    if (_isLoading) return false;

    _errorMessage = null;

    if (!validateForm()) {
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authProvider.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: nameController.text.trim(),
      );

      if (!success) {
        _errorMessage =
            _authProvider.errorMessage ??
            'Unable to create your account. Please try again.';
      }

      return success;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // CLEAR ERROR
  // ----------------------------------------------------------

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  // ----------------------------------------------------------
  // DISPOSE
  // ----------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
