import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import '../../domain/entities/deposit.dart';
import '../../domain/repositories/deposits_repository.dart';

class DepositsController extends StateNotifier<AsyncValue<List<Deposit>>> {
  final DepositsRepository repository;

  DepositsController(this.repository) : super(const AsyncValue.loading());

  void setDeposits(List<Deposit> deposits) {
    state = AsyncValue.data(deposits);
  }

  Future<void> fetchDeposits({
    String? status,
    String? customerName,
    int? page,
    int? limit,
  }) async {
    state = const AsyncValue.loading();

    final Either<Failure, List<Deposit>> result = await repository.getDeposits(
      status: status,
      customerName: customerName,
      page: page,
      limit: limit,
    );

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (deposits) => AsyncValue.data(deposits),
    );
  }

  Future<Deposit> createDeposit({
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required double amount,
    String? description,
    DateTime? expiryDate,
  }) async {
    final result = await repository.createDeposit(
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      amount: amount,
      description: description,
      expiryDate: expiryDate,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (deposit) => deposit,
    );
  }

  Future<Deposit> updateDeposit({
    required int id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    double? amount,
    String? description,
    DateTime? expiryDate,
    String? status,
  }) async {
    final result = await repository.updateDeposit(
      id: id,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      amount: amount,
      description: description,
      expiryDate: expiryDate,
      status: status,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (deposit) => deposit,
    );
  }

  Future<void> deleteDeposit(int id) async {
    final previousDeposits = state.hasValue ? state.value : null;

    if (previousDeposits != null) {
      state = AsyncValue.data(
        previousDeposits.where((deposit) => deposit.id != id).toList(),
      );
    }

    final result = await repository.deleteDeposit(id);

    result.fold(
      (failure) {
        if (previousDeposits != null) {
          state = AsyncValue.data(previousDeposits);
        }
        throw Exception(failure.message);
      },
      (_) {},
    );
  }
}

class DepositStatsController extends StateNotifier<AsyncValue<DepositStats>> {
  final DepositsRepository repository;

  DepositStatsController(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchStats() async {
    state = const AsyncValue.loading();

    final Either<Failure, DepositStats> result = await repository.getDepositStats();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (stats) => AsyncValue.data(stats),
    );
  }
}

class DepositDetailController extends StateNotifier<AsyncValue<Deposit>> {
  final DepositsRepository repository;

  DepositDetailController(this.repository, int id) : super(const AsyncValue.loading()) {
    fetchDeposit(id);
  }

  Future<void> fetchDeposit(int id) async {
    state = const AsyncValue.loading();

    final Either<Failure, Deposit> result = await repository.getDepositById(id);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (deposit) => AsyncValue.data(deposit),
    );
  }
}
