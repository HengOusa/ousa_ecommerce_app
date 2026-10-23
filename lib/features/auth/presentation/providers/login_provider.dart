// lib/features/auth/presentation/providers/login_provider.dart

import 'package:flutter/material.dart';
import 'package:ecom_app/features/auth/presentation/providers/auth_provider.dart';

class LoginProvider extends ChangeNotifier {
  final AuthProvider _authProvider; // optional but recommended

  LoginProvider(this._authProvider);

  // ── Form Controllers ────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // ── Main Login Method ───────────────────────────────────
  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authProvider.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!success) {
        _errorMessage = _authProvider.errorMessage ?? 'Login failed';
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
