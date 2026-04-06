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
        state = AsyncError(failure.message, StackTrace.current);
      },
      (user) {
        if (!user.isActive) {
          state = AsyncError("Your account is deactivated. Please contact admin.", StackTrace.current);
          return;
        }
        state = AsyncData(user);
      },
    );
  }

  Future<void> logout() async {
    await repository.logout();
    state = const AsyncData(null);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final currentUser = state.value;
    if (currentUser == null) return;
    
    // Setting state to loading while preserving current user data
    state = const AsyncLoading<User?>().copyWithPrevious(state);
    
    final result = await repository.changePassword(currentPassword, newPassword);
    
    result.fold(
      (failure) => state = AsyncError<User?>(failure.message, StackTrace.current).copyWithPrevious(state),
      (success) => state = AsyncData(currentUser),
    );
  }

  Future<void> registerEmployee({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final result = await repository.registerEmployee(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (success) => null,
    );
  }
}
