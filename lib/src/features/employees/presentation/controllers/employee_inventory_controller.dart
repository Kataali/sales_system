import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/employees/data/datasources/employee_remote_datasource.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';

class EmployeeInventoryController
    extends StateNotifier<AsyncValue<List<EmployeeInventoryItem>>> {
  final EmployeeRemoteDatasource datasource;

  EmployeeInventoryController(this.datasource)
      : super(const AsyncValue.loading()) {
    fetchInventory();
  }

  Future<void> fetchInventory() async {
    try {
      state = const AsyncValue.loading();
      final inventory = await datasource.fetchInventory();
      state = AsyncValue.data(inventory);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
