import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/sales/data/datasources/sales_datasource.dart';
import 'package:sales_system/src/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/domain/repositories/sales_repository.dart';
import 'package:sales_system/src/features/sales/presentation/controllers/sales_controller.dart';

final salesDatasourceProvider = Provider<SalesRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return SalesRemoteDatasource(storage: storage);
});

final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final datasource = ref.read(salesDatasourceProvider);
  return SalesRepositoryImpl(datasource: datasource);
});

final salesControllerProvider =
    StateNotifierProvider<SalesController, AsyncValue<List<SaleEntity>>>((ref) {
  final repository = ref.read(salesRepositoryProvider);
  final controller = SalesController(repository);

  final authState = ref.watch(authControllerProvider);
  authState.whenData((user) {
    if (user != null) {
      controller.fetchSales();
    } else {
      controller.setSales([]);
    }
  });

  return controller;
});
