import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/deposits/domain/entities/deposit.dart';

abstract class DepositsRepository {
  Future<Either<Failure, List<Deposit>>> getDeposits({
    String? status,
    String? customerName,
    int? page,
    int? limit,
  });
  Future<Either<Failure, DepositStats>> getDepositStats();
  Future<Either<Failure, Deposit>> getDepositById(int id);
  Future<Either<Failure, Deposit>> createDeposit({
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required double amount,
    String? description,
    DateTime? expiryDate,
  });
  Future<Either<Failure, Deposit>> updateDeposit({
    required int id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    double? amount,
    String? description,
    DateTime? expiryDate,
    String? status,
  });
  Future<Either<Failure, void>> deleteDeposit(int id);
}
