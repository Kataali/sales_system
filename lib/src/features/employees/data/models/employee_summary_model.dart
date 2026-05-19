import 'package:sales_system/src/features/employees/data/models/employee_inventory_model.dart';
import 'package:sales_system/src/features/employees/domain/entities/employee_summary.dart';
import 'package:sales_system/src/features/sales/data/models/sale_model.dart';

class EmployeeSummaryModel extends EmployeeSummary {
  const EmployeeSummaryModel({
    required super.todaySales,
    required super.todayRevenue,
    required super.lowStockProducts,
  });

  factory EmployeeSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final salesJson = data['todaySales'] as List<dynamic>? ?? const [];
    final lowStockJson = data['lowStockProducts'] as List<dynamic>? ?? const [];

    return EmployeeSummaryModel(
      todaySales: salesJson
          .whereType<Map<String, dynamic>>()
          .map(SaleModel.fromJson)
          .toList(),
      todayRevenue:
          double.tryParse(data['todayRevenue']?.toString() ?? '') ?? 0,
      lowStockProducts: lowStockJson
          .whereType<Map<String, dynamic>>()
          .map(EmployeeInventoryItemModel.fromJson)
          .toList(),
    );
  }
}
