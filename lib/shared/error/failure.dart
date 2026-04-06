import 'package:sales_system/shared/error/server_exception.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  /// Field-level validation errors, populated when the server returns a
  /// 400 response with an `errors` array.
  final List<FieldError> fieldErrors;

  ServerFailure(super.message, {this.fieldErrors = const []});

  /// Convenience factory to build directly from a [ServerException].
  factory ServerFailure.fromException(ServerException e) =>
      ServerFailure(e.message, fieldErrors: e.errors);

  bool get hasFieldErrors => fieldErrors.isNotEmpty;
}

class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}