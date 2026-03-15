import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/auth_datasource.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/authentication/datasources/repositories/auth_repository_impl.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/presentation/controllers/auth_controller.dart';

final authDatasourceProvider = Provider((ref) => AuthRemoteDatasource());
final authSecureStorageProvider =
    Provider<AuthSecureStorage>((ref) => AuthSecureStorage());

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(
      ref.read(authDatasourceProvider),
      ref.read(authSecureStorageProvider),
    ));

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return AuthController(repository);
});
