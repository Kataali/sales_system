import 'package:sales_system/src/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.overview,
    required super.inventory,
    required super.transactions,
    required super.topProducts,
    required super.recentSales,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final overviewJson = json['overview'] ?? {};
    return DashboardModel(
      overview: Overview(
        totalRevenue: double.tryParse(
                overviewJson['totalRevenue']?.toString() ?? '0.0') ??
            0.0,
        todayRevenue: double.tryParse(
                overviewJson['todayRevenue']?.toString() ?? '0.0') ??
            0.0,
        totalSales:
            int.tryParse(overviewJson['totalSales']?.toString() ?? '0') ?? 0,
        totalDeposits: double.tryParse(
                overviewJson['totalDeposits']?.toString() ?? '0.0') ??
            0.0,
        todayDeposits: double.tryParse(
                overviewJson['todayDeposits']?.toString() ?? '0.0') ??
            0.0,
        totalCashflow: (double.tryParse(
                    overviewJson['totalRevenue']?.toString() ?? '0.0') ??
                0.0) +
            (double.tryParse(
                    overviewJson['totalDeposits']?.toString() ?? '0.0') ??
                0.0),
        todayCashflow: (double.tryParse(
                    overviewJson['todayRevenue']?.toString() ?? '0.0') ??
                0.0) +
            (double.tryParse(
                    overviewJson['todayDeposits']?.toString() ?? '0.0') ??
                0.0),
        customerCount:
            int.tryParse(overviewJson['customerCount']?.toString() ?? '0') ?? 0,
      ),
      inventory: InventoryStatus(
        lowStock: int.tryParse(
                json['inventoryStatus']?['lowStock']?.toString() ?? '0') ??
            0,
        healthy: int.tryParse(
                json['inventoryStatus']?['healthy']?.toString() ?? '0') ??
            0,
        outOfStock: int.tryParse(
                json['inventoryStatus']?['outOfStock']?.toString() ?? '0') ??
            0,
        totalItems: int.tryParse(
                json['inventoryStatus']?['totalItems']?.toString() ?? '0') ??
            0,
      ),
      transactions: (json['recentTransactions'] as List?)
              ?.map((e) => TransactionEntity(
                    id: e['id'],
                    item: e['item'],
                    amount: double.tryParse(e['amount'].toString()) ?? 0.0,
                    time: DateTime.parse(e['time']),
                    type: e['type'],
                  ))
              .toList() ??
          [],
      topProducts: (json['topSellingProducts'] as List?)
              ?.map((e) => TopProductEntity(
                    name:
                        e['Product'] != null ? e['Product']['name'] : e['name'],
                    revenue:
                        double.tryParse(e['totalRevenue'].toString()) ?? 0.0,
                    salesCount: int.tryParse(e['salesCount'].toString()) ?? 0,
                  ))
              .toList() ??
          [],
      recentSales: (json['recentSales'] as List?)
              ?.map((sale) => RecentSaleEntity(
                    saleId: sale['id'] ?? 0,
                    userId: sale['userId'] ?? 0,
                    userName: sale['User']?['name'] ??
                        'Unknown User', // Added userName mapping
                    totalAmount: double.tryParse(
                            sale['totalAmount']?.toString() ?? '') ??
                        0.0,
                    status: sale['status'] ?? 'completed',
                    createdAt: DateTime.parse(
                        sale['createdAt'] ?? DateTime.now().toIso8601String()),
                    items: (sale['SaleItems'] as List?)
                            ?.map((item) => SaleItemSummary(
                                  productName: item['Product']?['name'] ??
                                      'Unknown Product',
                                  quantity: item['quantity'] ?? 1,
                                  selectedSize: item['selectedSize'] ?? 'N/A',
                                  unitPrice: double.tryParse(
                                          item['unitPrice']?.toString() ??
                                              '') ??
                                      0.0,
                                  totalAmount: double.tryParse(
                                          item['totalAmount']?.toString() ??
                                              '') ??
                                      0.0,
                                ))
                            .toList() ??
                        [],
                  ))
              .toList() ??
          [],
    );
  }
}
