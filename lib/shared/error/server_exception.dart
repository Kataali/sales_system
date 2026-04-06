/// Represents a single field-level validation error returned by the API.
/// Matches the shape: { "type": "field", "msg": "...", "path": "email", ... }
class FieldError {
  final String path;
  final String msg;
  final String? value;

  const FieldError({
    required this.path,
    required this.msg,
    this.value,
  });

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      path: json['path']?.toString() ?? '',
      msg: json['msg']?.toString() ?? 'Invalid value',
      value: json['value']?.toString(),
    );
  }

  @override
  String toString() => '$path: $msg';
}

/// [Exception] thrown when the server returns a non-2xx response.
///
/// For 400 validation errors with an `errors` array, [errors] is populated
/// and [hasFieldErrors] is true.
/// For other failures, [message] contains the human-readable reason.
class ServerException implements Exception {
  final int statusCode;
  final String message;
  final List<FieldError> errors;

  const ServerException({
    required this.statusCode,
    required this.message,
    this.errors = const [],
  });

  bool get hasFieldErrors => errors.isNotEmpty;

  /// Parses a raw API JSON body into a [ServerException].
  ///
  /// Handles the two server shapes:
  ///   - Validation: `{ "errors": [{ "path": "email", "msg": "..." }] }`
  ///   - General:    `{ "message": "..." }` or `{ "error": { "message": "..." } }`
  factory ServerException.fromJson(Map<String, dynamic> json, int statusCode) {
    final rawErrors = json['errors'];

    final List<FieldError> fieldErrors = (rawErrors is List)
        ? rawErrors
            .whereType<Map<String, dynamic>>()
            .map(FieldError.fromJson)
            .toList()
        : [];

    final message = fieldErrors.isNotEmpty
        ? fieldErrors
            .map((e) => '${_capitalize(e.path)}: ${e.msg}')
            .join('\n')
        : (json['message']?.toString() ??
            json['error']?['message']?.toString() ??
            'An unexpected error occurred ($statusCode)');

    return ServerException(
      statusCode: statusCode,
      message: message,
      errors: fieldErrors,
    );
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  String toString() => message;
}
