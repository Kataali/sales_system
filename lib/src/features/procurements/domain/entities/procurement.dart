class ProcurementEntity {
  final int id;
  final int? userId;
  final String? supplierName;
  final String? referenceNumber;
  final double totalCost;
  final String status;
  final DateTime procuredAt;
  final String? userName;
  final List<ProcurementItemEntity> items;

  ProcurementEntity({
    required this.id,
    this.userId,
    this.supplierName,
    this.referenceNumber,
    required this.totalCost,
    this.status = 'completed',
    required this.procuredAt,
    this.userName,
    this.items = const [],
  });
}

class ProcurementItemEntity {
  final int id;
  final int productId;
  final String? selectedSize;
  final int quantity;
  final double unitCost;
  final double totalCost;
  final String? productName;
  final String? productSku;
  final String? productImageUrl;

  ProcurementItemEntity({
    required this.id,
    required this.productId,
    this.selectedSize,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    this.productName,
    this.productSku,
    this.productImageUrl,
  });
}
