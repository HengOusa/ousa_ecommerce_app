class SupabaseException implements Exception {
  final String message;
  final String? code;

  const SupabaseException(this.message, {this.code});

  @override
  String toString() => 'SupabaseException($code): $message';
}
