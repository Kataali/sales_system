import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/domain/repositories/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository repository;

  AuthController(this.repository) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    final result = await repository.login(email, password);

    result.fold(
      (failure) {
        state = AsyncError(failure.message, StackTrace.empty);
      },
      (user) {
        state = AsyncData(user);
      },
    );
  }
}
