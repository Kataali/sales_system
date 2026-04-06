/// [Exception] thrown for server related error and device error
class DeviceException implements Exception {
  /// Constructor for exceptions
  DeviceException(this.message, {this.statusCode = 404});

  /// Convert error messages from api
  factory DeviceException.fromJson(
    Map<String, dynamic> json, {
    int code = 404,
  }) => DeviceException(json['detail'] as String, statusCode: code);

  /// Error message
  final String message;

  /// Error code
  final int statusCode;

  @override
  String toString() => message;
}

/// [Exception] thrown when there is no network connectivity or the backend
/// server cannot be reached (e.g. [SocketException], timeout).
class NetworkException implements Exception {
  final String message;

  const NetworkException([this.message = 'No internet connection. Please check your network settings.']);

  @override
  String toString() => message;
}
