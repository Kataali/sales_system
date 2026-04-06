class DashboardEntity {
  final Overview overview;
  final InventoryStatus inventory;
  final List<TransactionEntity> transactions;
  final List<TopProductEntity> topProducts;

  DashboardEntity({
    required this.overview,
    required this.inventory,
    required this.transactions,
    required this.topProducts,
  });
}

class Overview {
  final int totalRevenue;
  final int todayRevenue;
  final int totalSales;
  final int customerCount;

  Overview({
    required this.totalRevenue,
    required this.todayRevenue,
    required this.totalSales,
    required this.customerCount,
  });
}

class InventoryStatus {
  final List lowStock;
  final List healthy;
  final List outOfStock;
  final int totalItems;

  InventoryStatus({
    required this.lowStock,
    required this.healthy,
    required this.outOfStock,
    required this.totalItems,
  });
}

class TransactionEntity {
  final String productName;
  final int quantity;
  final double totalAmount;
  final DateTime createdAt;

  TransactionEntity({
    required this.productName,
    required this.quantity,
    required this.totalAmount,
    required this.createdAt,
  });
}

class TopProductEntity {
  final String name;
  final double revenue;
  final int salesCount;

  TopProductEntity({
    required this.name,
    required this.revenue,
    required this.salesCount,
  });
}
