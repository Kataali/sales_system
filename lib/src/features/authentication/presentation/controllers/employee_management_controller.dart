import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/domain/entities/user.dart';
import 'package:sales_system/src/features/authentication/domain/repositories/auth_repository.dart';

class EmployeeManagementController extends StateNotifier<AsyncValue<List<User>>> {
  final AuthRepository repository;

  EmployeeManagementController(this.repository) : super(const AsyncLoading()) {
    getEmployees();
  }

  Future<void> getEmployees() async {
    state = const AsyncLoading();
    final result = await repository.getEmployees();
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (employees) => state = AsyncData(employees),
    );
  }

  Future<void> toggleEmployeeStatus(String id, bool currentStatus) async {
    final nextStatus = !currentStatus;
    
    // Optimistic update
    final previousState = state;
    if (state.hasValue) {
      final updatedList = state.value!.map((u) {
        if (u.id == id) {
          return User(
            id: u.id,
            name: u.name,
            email: u.email,
            role: u.role,
            isActive: nextStatus,
            mustChangePassword: u.mustChangePassword,
          );
        }
        return u;
      }).toList();
      state = AsyncData(updatedList);
    }

    final result = await repository.updateEmployeeStatus(id, nextStatus);
    
    result.fold(
      (failure) {
        state = previousState; // Rollback
        throw Exception(failure.message);
      },
      (_) => null,
    );
  }

  Future<String> resetEmployeePassword(String id) async {
    final result = await repository.resetEmployeePassword(id);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (newPassword) {
        if (state.hasValue) {
          final updatedList = state.value!.map((u) {
            if (u.id == id) {
              return User(
                id: u.id,
                name: u.name,
                email: u.email,
                role: u.role,
                isActive: u.isActive,
                mustChangePassword: true,
              );
            }
            return u;
          }).toList();
          state = AsyncData(updatedList);
        }
        return newPassword;
      },
    );
  }
}
