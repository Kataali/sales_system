class SaleEntity {
  final int id;
  final int userId;
  final double totalAmount;
  final String status;
  final int? depositId;
  final bool isCollected;
  final DateTime? collectedAt;
  final String? customerName;
  final String? customerPhone;
  final String? userName;
  final List<SaleItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  SaleEntity({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    this.depositId,
    this.isCollected = true,
    this.collectedAt,
    this.customerName,
    this.customerPhone,
    this.userName,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}

class SaleItemEntity {
  final int id;
  final int saleId;
  final int productId;
  final int quantity;
  final String selectedSize;
  final double unitPrice;
  final double totalAmount;
  final String status;
  final String? productName;
  final String? productSku;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SaleItemEntity({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.totalAmount,
    required this.status,
    this.productName,
    this.productSku,
    required this.createdAt,
    this.updatedAt,
  });
}
