import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';
import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';

class EmployeeSummary {
  final List<SaleEntity> todaySales;
  final double todayRevenue;
  final List<EmployeeInventoryItem> lowStockProducts;

  const EmployeeSummary({
    required this.todaySales,
    required this.todayRevenue,
    required this.lowStockProducts,
  });
}
