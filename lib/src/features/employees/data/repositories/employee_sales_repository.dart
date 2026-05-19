import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import 'package:sales_system/src/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/domain/repositories/sales_repository.dart';

class EmployeeSalesRepository implements SalesRepository {
  final EmployeeRemoteDatasource datasource;

  const EmployeeSalesRepository({required this.datasource});

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
