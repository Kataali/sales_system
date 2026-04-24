import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import '../../domain/entities/deposit.dart';
import '../../domain/repositories/deposits_repository.dart';
import '../datasources/deposits_datasource.dart';

class DepositsRepositoryImpl implements DepositsRepository {
  final DepositsRemoteDatasource datasource;

  DepositsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<Deposit>>> getDeposits({
    String? status,
    String? customerName,
    int? page,
    int? limit,
  }) async {
    try {
      final deposits = await datasource.getDeposits(
        status: status,
        customerName: customerName,
        page: page,
        limit: limit,
      );
      return Right(deposits);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepositStats>> getDepositStats() async {
    try {
      final stats = await datasource.getDepositStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Deposit>> getDepositById(int id) async {
    try {
      final deposit = await datasource.getDepositById(id);
      return Right(deposit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Deposit>> createDeposit({
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required double amount,
    String? description,
    DateTime? expiryDate,
  }) async {
    try {
      final deposit = await datasource.createDeposit(
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        amount: amount,
        description: description,
        expiryDate: expiryDate,
      );
      return Right(deposit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Deposit>> updateDeposit({
    required int id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    double? amount,
    String? description,
    DateTime? expiryDate,
    String? status,
  }) async {
    try {
      final deposit = await datasource.updateDeposit(
        id: id,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        amount: amount,
        description: description,
        expiryDate: expiryDate,
        status: status,
      );
      return Right(deposit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDeposit(int id) async {
    try {
      await datasource.deleteDeposit(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
