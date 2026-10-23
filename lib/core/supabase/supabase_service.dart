import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';
import 'supabase_exception.dart';

/// Base class for all repositories.
/// Handles common error mapping and provides the client.
abstract class SupabaseService {
  SupabaseClient get client => SupabaseClientProvider.client;

  Never handleError(Object error, [StackTrace? stack]) {
    if (error is PostgrestException) {
      throw SupabaseException(error.message, code: error.code);
    }
    if (error is AuthException) {
      throw SupabaseException(error.message, code: error.statusCode);
    }
    throw SupabaseException(error.toString());
  }
}
