import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/auth_datasource.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/authentication/datasources/repositories/auth_repository_impl.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:sales_system/src/features/authentication/presentation/controllers/employee_management_controller.dart';

final authSecureStorageProvider =
    Provider<AuthSecureStorage>((ref) => AuthSecureStorage());

final authDatasourceProvider = Provider((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return AuthRemoteDatasource(storage);
});

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(
      ref.read(authDatasourceProvider),
      ref.read(authSecureStorageProvider),
    ));

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return AuthController(repository);
});

final employeeManagementProvider =
    StateNotifierProvider<EmployeeManagementController, AsyncValue<List<User>>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return EmployeeManagementController(repository);
});
