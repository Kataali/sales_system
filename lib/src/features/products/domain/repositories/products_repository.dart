import 'dart:typed_data';
import 'package:sales_system/shared/error/failure.dart';

import '../entities/product.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> fetchProducts();
  Future<Either<Failure, void>> createProduct({
    required String name,
    Uint8List? imageBytes,
    String? imageName,
    required String sku,
    required List<ProductVariant> variants,
    required int totalStock,
  });
}
