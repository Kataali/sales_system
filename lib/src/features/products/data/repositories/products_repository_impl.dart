import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDatasource datasource;

  ProductsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<Product>>> fetchProducts() async {
    try {
      final products = await datasource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
