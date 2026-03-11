import 'package:sales_system/shared/error/failure.dart';

import '../entities/product.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> fetchProducts();
}
