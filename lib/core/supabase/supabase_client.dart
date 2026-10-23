import 'package:supabase_flutter/supabase_flutter.dart';

/// Single source of truth for the Supabase client.
/// Never call Supabase.instance.client directly in features.
class SupabaseClientProvider {
  SupabaseClientProvider._();
  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => client.auth;
  static SupabaseStorageClient get storage => client.storage;
  static RealtimeClient get realtime => client.realtime;
}
