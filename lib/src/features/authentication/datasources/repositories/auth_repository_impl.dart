import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/authentication/datasources/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthSecureStorage storage;

  AuthRepositoryImpl(this.remoteDatasource, this.storage);

  @override
  Future<Either<Failure, User>> login(
    String email,
    String password,
  ) async {
    try {
      // final user = await remoteDatasource.login(email, password);

      // return Right(user);
      final json = await remoteDatasource.login(email, password);

      final token = json['token'];

      await storage.saveAccessToken(token);

      // Confirm token storage
      final storedToken = await storage.getAccessToken();
      print("Stored token: $storedToken");

      return Right(UserModel.fromJson(json['user']));
    } on HttpException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
