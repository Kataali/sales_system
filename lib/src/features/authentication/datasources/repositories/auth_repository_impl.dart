import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/exception.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/shared/error/server_exception.dart';
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
      print("Logging in with: $email");
      final json = await remoteDatasource.login(email, password);
      print("Login API Response: $json");

      final data = json.containsKey('data') ? json['data'] : json;
      
      final token = data['token'];
      final userData = data['user'];

      if (token == null || userData == null) {
        print("Login Error: Missing token or user in data structure: $data");
        return Left(ServerFailure("Invalid login response from server: Missing token or user data."));
      }

      await storage.saveAccessToken(token);
      print("Token saved successfully");

      return Right(UserModel.fromJson(userData));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure('Cannot reach the server. Make sure the backend is running.'));
    } on ServerException catch (e) {
      print("Login Server Error [${e.statusCode}]: ${e.message}");
      return Left(ServerFailure.fromException(e));
    } on HttpException catch (e) {
      print("Login Http Error: ${e.message}");
      return Left(ServerFailure(e.message));
    } catch (e) {
      print("Login Unexpected Error: $e");
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await storage.deleteTokens();
  }

  @override
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await remoteDatasource.changePassword(currentPassword, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerEmployee({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await remoteDatasource.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure('Cannot reach the server. Make sure the backend is running.'));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getEmployees() async {
    try {
      final jsonList = await remoteDatasource.getEmployees();
      final employees = jsonList.map((j) => UserModel.fromJson(j)).toList();
      return Right(employees);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployeeStatus(String id, bool isActive) async {
    try {
      await remoteDatasource.updateEmployeeStatus(id, isActive);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetEmployeePassword(String id) async {
    try {
      final response = await remoteDatasource.resetEmployeePassword(id);
      final employee = response['employee'];
      final newPassword = employee?['currentPassword'];

      if (newPassword == null) {
        return Left(ServerFailure('Response did not contain the new password.'));
      }

      return Right(newPassword.toString());
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
