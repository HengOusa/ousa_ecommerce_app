import 'package:ecom_app/core/supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends SupabaseService {
  // ==========================================================
  // SIGN IN
  // ==========================================================

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  // ==========================================================
  // SIGN UP
  // ==========================================================

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      return await client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  // ==========================================================
  // SIGN OUT
  // ==========================================================

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  // ==========================================================
  // GET USER PROFILE
  // ==========================================================

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  // ==========================================================
  // UPDATE USER PROFILE
  // ==========================================================

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? deliveryAddress,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (fullName != null) {
        updates['full_name'] = fullName.trim();
      }

      if (phoneNumber != null) {
        updates['phone_number'] = phoneNumber.trim();
      }

      if (deliveryAddress != null) {
        updates['delivery_address'] = deliveryAddress.trim();
      }

      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl.trim();
      }

      // Avoid sending an empty update.
      if (updates.isEmpty) return;

      await client.from('profiles').update(updates).eq('id', userId);
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  // ==========================================================
  // AUTHENTICATION STATE
  // ==========================================================

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ==========================================================
  // CURRENT USER AND SESSION
  // ==========================================================

  User? get currentUser => client.auth.currentUser;

  Session? get currentSession => client.auth.currentSession;

  bool get isAuthenticated => currentUser != null;
}
