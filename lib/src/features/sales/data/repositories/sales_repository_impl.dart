import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/sales/data/datasources/sales_datasource.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDatasource datasource;

  SalesRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<SaleEntity>>> fetchSales() async {
    try {
      final sales = await datasource.fetchSales();
      return Right(sales);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
