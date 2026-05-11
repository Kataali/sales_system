class DashboardEntity {
  final Overview overview;
  final InventoryStatus inventory;
  final List<TransactionEntity> transactions;
  final List<TopProductEntity> topProducts;
  final List<RecentSaleEntity> recentSales;

  DashboardEntity({
    required this.overview,
    required this.inventory,
    required this.transactions,
    required this.topProducts,
    required this.recentSales,
  });
}

class Overview {
  final double totalRevenue;
  final double todayRevenue;
  final int totalSales;
  final double totalDeposits;
  final double todayDeposits;
  final double totalCashflow;
  final double todayCashflow;
  final int customerCount;

  Overview({
    required this.totalRevenue,
    required this.todayRevenue,
    required this.totalSales,
    required this.totalDeposits,
    required this.todayDeposits,
    required this.totalCashflow,
    required this.todayCashflow,
    required this.customerCount,
  });
}

class InventoryStatus {
  final int lowStock;
  final int healthy;
  final int outOfStock;
  final int totalItems;

  InventoryStatus({
    required this.lowStock,
    required this.healthy,
    required this.outOfStock,
    required this.totalItems,
  });
}

class TransactionEntity {
  final dynamic id;
  final String item;
  final double amount;
  final DateTime time;
  final String type;

  TransactionEntity({
    required this.id,
    required this.item,
    required this.amount,
    required this.time,
    required this.type,
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

class RecentSaleEntity {
  final int saleId;
  final int userId;
  final String userName; // Added userName field
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<SaleItemSummary> items;

  RecentSaleEntity({
    required this.saleId,
    required this.userId,
    required this.userName, // Added userName parameter
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });
}

class SaleItemSummary {
  final String productName;
  final int quantity;
  final String selectedSize;
  final double unitPrice;
  final double totalAmount;

  SaleItemSummary({
    required this.productName,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.totalAmount,
  });
}

class UserEntity {
  final int id;
  final String name;
  final bool isActive;
  final bool mustChangePassword;

  UserEntity({
    required this.id,
    required this.name,
    required this.isActive,
    required this.mustChangePassword,
  });
}
