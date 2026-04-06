import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.overview,
    required super.inventory,
    required super.transactions,
    required super.topProducts,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      overview: Overview(
        totalRevenue: json['overview']['totalRevenue'],
        todayRevenue: json['overview']['todayRevenue'],
        totalSales: json['overview']['totalSales'],
        customerCount: json['overview']['customerCount'],
      ),
      inventory: InventoryStatus(
        lowStock: json['inventoryStatus']['lowStock'],
        healthy: json['inventoryStatus']['healthy'],
        outOfStock: json['inventoryStatus']['outOfStock'],
        totalItems: json['inventoryStatus']['totalItems'],
      ),
      transactions: (json['recentTransactions'] as List)
          .map((e) => TransactionEntity(
                productName: e['productName'],
                quantity: e['quantity'],
                totalAmount: double.parse(e['totalAmount']),
                createdAt: DateTime.parse(e['createdAt']),
              ))
          .toList(),
      topProducts: (json['topSellingProducts'] as List)
          .map((e) => TopProductEntity(
                name: e['Product']['name'],
                revenue: double.parse(e['totalRevenue']),
                salesCount: int.parse(e['salesCount']),
              ))
          .toList(),
    );
  }
}
