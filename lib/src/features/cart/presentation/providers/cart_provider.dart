import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/cart/data/datasources/cart_datasource.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:sales_system/src/features/cart/presentation/controllers/cart_controller.dart';

final cartDatasourceProvider = Provider<CartRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return CartRemoteDatasource(storage);
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final datasource = ref.read(cartDatasourceProvider);
  final storage = ref.read(authSecureStorageProvider);

  return CartRepositoryImpl(datasource, storage);
});

final cartControllerProvider =
    StateNotifierProvider<CartController, AsyncValue<List<CartItem>>>((ref) {
  final repository = ref.read(cartRepositoryProvider);
  return CartController(repository);
});
