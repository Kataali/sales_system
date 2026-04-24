import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/procurements/data/datasources/procurements_datasource.dart';
import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';
import 'package:sales_system/src/features/procurements/domain/repositories/procurements_repository.dart';

class ProcurementsRepositoryImpl implements ProcurementsRepository {
  final ProcurementsRemoteDatasource datasource;

  ProcurementsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<ProcurementEntity>>> fetchProcurements({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final procurements = await datasource.fetchProcurements(
        page: page,
        limit: limit,
      );
      return Right(procurements);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProcurementEntity>> fetchProcurementById(int id) async {
    try {
      final procurement = await datasource.fetchProcurementById(id);
      return Right(procurement);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProcurementEntity>> createProcurement({
    String? supplierName,
    String? referenceNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final procurement = await datasource.createProcurement(
        supplierName: supplierName,
        referenceNumber: referenceNumber,
        items: items,
      );
      return Right(procurement);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
