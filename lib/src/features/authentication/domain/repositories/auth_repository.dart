import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(
    String email,
    String password,
  );

  Future<void> logout();

  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );

  Future<Either<Failure, void>> registerEmployee({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, List<User>>> getEmployees();

  Future<Either<Failure, void>> updateEmployeeStatus(String id, bool isActive);
  Future<Either<Failure, String>> resetEmployeePassword(String id);
}
