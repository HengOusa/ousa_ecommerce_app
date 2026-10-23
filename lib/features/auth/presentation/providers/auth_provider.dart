import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo) {
    _init();
  }

  final AuthRepository _repo;

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  Map<String, dynamic>? _profile;
  String? _errorMessage;

  StreamSubscription<AuthState>? _authSubscription;

  bool _isDisposed = false;
  bool _isBusy = false;

  // ----------------------------------------------------------
  // GETTERS
  // ----------------------------------------------------------

  AuthStatus get status => _status;

  User? get user => _user;

  Map<String, dynamic>? get profile => _profile;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _repo.currentSession != null;

  bool get isLoading => _isBusy || _status == AuthStatus.loading;

  bool get isAdmin => _profile?['role'] == 'admin';

  bool get hasActiveSession => _repo.currentSession != null;

  String? get userId => _user?.id;

  String? get email => _user?.email;

  String? get fullName =>
      _profile?['full_name'] as String? ??
      _user?.userMetadata?['full_name'] as String?;

  // ----------------------------------------------------------
  // INITIALIZATION
  // ----------------------------------------------------------

  Future<void> _init() async {
    // Subscribe first so authentication changes are observed.
    _authSubscription = _repo.authStateChanges.listen(
      (state) {
        unawaited(_onAuthStateChanged(state));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (_isDisposed) return;

        debugPrint('Auth state listener error: $error');

        _errorMessage = 'Unable to monitor authentication state.';
        _notifyListeners();
      },
    );

    // Restore the session that Supabase persisted between launches.
    final currentUser = _repo.currentUser;

    if (_isDisposed) return;

    if (currentUser == null) {
      _user = null;
      _profile = null;
      _status = AuthStatus.unauthenticated;
      _notifyListeners();
      return;
    }

    _user = currentUser;
    _profile = null;
    _status = AuthStatus.authenticated;
    _notifyListeners();

    await _loadProfile(currentUser.id);
  }

  // ----------------------------------------------------------
  // AUTH STATE LISTENER
  // ----------------------------------------------------------

  Future<void> _onAuthStateChanged(AuthState state) async {
    if (_isDisposed) return;

    final session = state.session;

    if (session == null) {
      _user = null;
      _profile = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;

      _notifyListeners();
      return;
    }

    final sessionUser = session.user;
    final hasChangedUser = _user?.id != sessionUser.id;

    _user = sessionUser;

    if (hasChangedUser) {
      _profile = null;
    }

    _status = AuthStatus.authenticated;
    _errorMessage = null;
    _notifyListeners();

    await _loadProfile(sessionUser.id);
  }

  // ----------------------------------------------------------
  // LOAD USER PROFILE
  // ----------------------------------------------------------

  Future<void> _loadProfile(String userId) async {
    try {
      final result = await _repo.getProfile(userId);

      if (_isDisposed || _user?.id != userId) return;

      _profile = result;
      _notifyListeners();
    } catch (error) {
      if (_isDisposed || _user?.id != userId) return;

      _profile = null;
      debugPrint('Failed to load user profile: $error');

      _notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // SIGN IN
  // ----------------------------------------------------------

  Future<bool> signIn({required String email, required String password}) async {
    if (isLoading) return false;

    _isBusy = true;
    _status = AuthStatus.loading;
    _errorMessage = null;
    _notifyListeners();

    try {
      final response = await _repo.signInWithEmail(
        email: email.trim(),
        password: password,
      );

      final signedInUser = response.user;

      if (signedInUser == null) {
        _errorMessage = 'Login failed. Please try again.';
        _user = _repo.currentUser;
        _status = _user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated;

        return false;
      }

      _user = signedInUser;
      _profile = null;
      _status = AuthStatus.authenticated;

      await _loadProfile(signedInUser.id);

      return true;
    } catch (error) {
      _errorMessage = _readableError(error);

      // Preserve any session that still exists.
      _user = _repo.currentUser;
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;

      if (_user == null) {
        _profile = null;
      }

      return false;
    } finally {
      _isBusy = false;
      _notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // SIGN UP
  // ----------------------------------------------------------

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (isLoading) return false;

    _isBusy = true;
    _status = AuthStatus.loading;
    _errorMessage = null;
    _notifyListeners();

    try {
      final response = await _repo.signUpWithEmail(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
      );

      final newUser = response.user;

      if (newUser == null) {
        _errorMessage = 'Account creation failed. Please try again.';
        _user = _repo.currentUser;
        _status = _user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated;

        return false;
      }

      if (response.session != null) {
        _user = newUser;
        _profile = null;
        _status = AuthStatus.authenticated;

        await _loadProfile(newUser.id);
      } else {
        // Account created, but email confirmation may be required.
        _user = null;
        _profile = null;
        _status = AuthStatus.unauthenticated;
      }

      return true;
    } catch (error) {
      _errorMessage = _readableError(error);

      _user = _repo.currentUser;
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;

      if (_user == null) {
        _profile = null;
      }

      return false;
    } finally {
      _isBusy = false;
      _notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // REFRESH PROFILE
  // ----------------------------------------------------------

  Future<void> refreshProfile() async {
    final id = _user?.id;

    if (id == null) return;

    await _loadProfile(id);
  }

  // ----------------------------------------------------------
  // UPDATE PROFILE
  // ----------------------------------------------------------

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? deliveryAddress,
    String? avatarUrl,
  }) async {
    final id = _user?.id;

    if (id == null || !hasActiveSession) {
      _errorMessage = 'Please sign in first.';
      _notifyListeners();
      return false;
    }

    _errorMessage = null;
    _notifyListeners();

    try {
      await _repo.updateProfile(
        userId: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        deliveryAddress: deliveryAddress,
        avatarUrl: avatarUrl,
      );

      await _loadProfile(id);
      return true;
    } catch (error) {
      _errorMessage = _readableError(error);
      _notifyListeners();
      return false;
    }
  }

  // ----------------------------------------------------------
  // SIGN OUT
  // ----------------------------------------------------------

  Future<bool> signOut() async {
    if (isLoading) return false;

    _isBusy = true;
    _status = AuthStatus.loading;
    _errorMessage = null;
    _notifyListeners();

    try {
      await _repo.signOut();

      // Ensure the repository really cleared the session.
      if (_repo.currentSession != null) {
        _errorMessage = 'Unable to complete logout. Please try again.';

        _user = _repo.currentUser;
        _status = _user != null
            ? AuthStatus.authenticated
            : AuthStatus.unauthenticated;

        return false;
      }

      _user = null;
      _profile = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;

      return true;
    } catch (error) {
      _errorMessage = _readableError(error);

      // Preserve authentication if logout failed and the session remains.
      _user = _repo.currentUser;
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;

      if (_user == null) {
        _profile = null;
      }

      return false;
    } finally {
      _isBusy = false;
      _notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // ERROR HANDLING
  // ----------------------------------------------------------

  String _readableError(Object error) {
    if (error is AuthException) {
      return error.message;
    }

    if (error is PostgrestException) {
      return error.message;
    }

    debugPrint('Authentication error: $error');

    return 'Something went wrong. Please try again.';
  }

  void _notifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ----------------------------------------------------------
  // DISPOSE
  // ----------------------------------------------------------

  @override
  void dispose() {
    _isDisposed = true;
    _authSubscription?.cancel();
    super.dispose();
  }
}
