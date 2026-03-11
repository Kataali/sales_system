import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/products/data/datasources/products_datasource.dart';
import 'package:sales_system/src/features/products/data/repositories/products_repository_impl.dart';
import 'package:sales_system/src/features/products/domain/repositories/products_repository.dart';
import 'package:sales_system/src/features/products/presentation/controllers/products_controller.dart';

final productsDatasourceProvider = Provider<ProductsRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return ProductsRemoteDatasource(storage: storage);
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final datasource = ref.read(productsDatasourceProvider);
  return ProductsRepositoryImpl(datasource: datasource);
});

final productsControllerProvider =
    StateNotifierProvider<ProductsController, AsyncValue<List<Product>>>((ref) {
  final repository = ref.read(productsRepositoryProvider);
  final controller = ProductsController(repository);

  // Watch auth state and fetch products when user exists
  final authState = ref.watch(authControllerProvider);
  authState.whenData((user) {
    if (user != null) {
      controller.fetchProducts();
    } else {
      controller.state = const AsyncValue.data([]);
    }
  });

  return controller;
});
