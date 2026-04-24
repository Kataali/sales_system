import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';

abstract class ProcurementsRepository {
  Future<Either<Failure, List<ProcurementEntity>>> fetchProcurements({
    int page = 1,
    int limit = 50,
  });

  Future<Either<Failure, ProcurementEntity>> fetchProcurementById(int id);

  Future<Either<Failure, ProcurementEntity>> createProcurement({
    String? supplierName,
    String? referenceNumber,
    required List<Map<String, dynamic>> items,
  });
}
