import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/authentication/presentation/providers/auth_provider.dart';
import 'package:sales_system/src/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:sales_system/src/features/employees/data/repositories/employee_sales_repository.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_summary.dart';
import 'package:sales_system/src/features/employees/presentation/controllers/employee_inventory_controller.dart';
import 'package:sales_system/src/features/employees/presentation/controllers/employee_summary_controller.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';
import 'package:sales_system/src/features/sales/domain/repositories/sales_repository.dart';
import 'package:sales_system/src/features/sales/presentation/controllers/sales_controller.dart';

final employeeDatasourceProvider = Provider<EmployeeRemoteDatasource>((ref) {
  final storage = ref.read(authSecureStorageProvider);
  return EmployeeRemoteDatasource(storage: storage);
});

final employeeSummaryControllerProvider = StateNotifierProvider<
    EmployeeSummaryController, AsyncValue<EmployeeSummary>>((ref) {
  final datasource = ref.read(employeeDatasourceProvider);
  return EmployeeSummaryController(datasource);
});

final employeeSalesRepositoryProvider = Provider<SalesRepository>((ref) {
  final datasource = ref.read(employeeDatasourceProvider);
  return EmployeeSalesRepository(datasource: datasource);
});

final employeeSalesControllerProvider =
    StateNotifierProvider<SalesController, AsyncValue<List<SaleEntity>>>((ref) {
  final repository = ref.read(employeeSalesRepositoryProvider);
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

final employeeInventoryControllerProvider = StateNotifierProvider<
    EmployeeInventoryController,
    AsyncValue<List<EmployeeInventoryItem>>>((ref) {
  final datasource = ref.read(employeeDatasourceProvider);
  return EmployeeInventoryController(datasource);
});
