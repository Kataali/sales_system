import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sales_system/shared/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsController extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductsRepository repository;

  ProductsController(this.repository) : super(const AsyncValue.loading());

  Future<void> fetchProducts() async {
    state = const AsyncValue.loading();

    final Either<Failure, List<Product>> result =
        await repository.fetchProducts();

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.empty),
      (products) => AsyncValue.data(products),
    );
  }

  void clear() {
    state = const AsyncValue.data([]);
  }

  Future<void> createProduct({
    required String name,
    Uint8List? imageBytes,
    String? imageName,
    required String sku,
    required List<ProductVariant> variants,
    required int totalStock,
  }) async {
    final result = await repository.createProduct(
      name: name,
      imageBytes: imageBytes,
      imageName: imageName,
      sku: sku,
      variants: variants,
      totalStock: totalStock,
    );

    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {},
    );
  }
}
