import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(
    String email,
    String password,
  );
}
