import 'dart:typed_data';
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

  @override
  Future<Either<Failure, void>> createProduct({
    required String name,
    Uint8List? imageBytes,
    String? imageName,
    required String sku,
    required List<ProductVariant> variants,
    required int totalStock,
  }) async {
    try {
      await datasource.createProduct(
        name: name,
        imageBytes: imageBytes,
        imageName: imageName,
        sku: sku,
        variants: variants
            .map(
              (variant) => {
                'size': variant.size,
                'price': variant.price,
                'stock': variant.stock,
              },
            )
            .toList(),
        totalStock: totalStock,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
