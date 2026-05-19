class EmployeeInventoryItem {
  final int productId;
  final String productName;
  final String status;
  final EmployeeInventoryVariant variant;

  const EmployeeInventoryItem({
    required this.productId,
    required this.productName,
    required this.status,
    required this.variant,
  });
}

class EmployeeInventoryVariant {
  final String size;
  final double price;
  final int stock;
  final double costPrice;
  final int lowStockThreshold;

  const EmployeeInventoryVariant({
    required this.size,
    required this.price,
    required this.stock,
    required this.costPrice,
    required this.lowStockThreshold,
  });
}
