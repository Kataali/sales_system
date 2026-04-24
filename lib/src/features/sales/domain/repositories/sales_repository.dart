import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';

abstract class SalesRepository {
  Future<Either<Failure, List<SaleEntity>>> fetchSales();
}
