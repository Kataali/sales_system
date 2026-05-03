class CheckoutResult {
  final bool success;
  final String message;
  final int saleId;
  final int userId;
  final double totalAmount;
  final String status;
  final bool isCollected;
  final DateTime? collectedAt;
  final String? customerName;
  final String? customerPhone;
  final List<SaleItem> saleItems;

  CheckoutResult({
    required this.success,
    required this.message,
    required this.saleId,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.isCollected,
    this.collectedAt,
    this.customerName,
    this.customerPhone,
    required this.saleItems,
  });

  factory CheckoutResult.fromJson(Map<String, dynamic> json) {
    final sales = (json['sales'] ?? json['sale']) as Map<String, dynamic>? ??
        <String, dynamic>{};
    final saleItems = ((sales['SaleItems'] as List<dynamic>?) ?? const [])
        .map((item) => SaleItem.fromJson(item))
        .toList();

    return CheckoutResult(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      saleId: sales['id'] ?? 0,
      userId: sales['userId'] ?? 0,
      totalAmount: double.tryParse(sales['totalAmount']?.toString() ?? '') ?? 0,
      status: sales['status']?.toString() ?? 'completed',
      isCollected: sales['isCollected'] ?? true,
      collectedAt: sales['collectedAt'] != null
          ? DateTime.tryParse(sales['collectedAt'].toString())
          : null,
      customerName: sales['customerName']?.toString(),
      customerPhone: sales['customerPhone']?.toString(),
      saleItems: saleItems,
    );
  }
}

class SaleItem {
  final int id;
  final int saleId;
  final int productId;
  final int quantity;
  final String selectedSize;
  final double unitPrice;
  final double totalAmount;
  final String status;

  SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.totalAmount,
    required this.status,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'],
      saleId: json['saleId'],
      productId: json['productId'],
      quantity: json['quantity'],
      selectedSize: json['selectedSize'],
      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '') ?? 0,
      totalAmount: double.tryParse(json['totalAmount']?.toString() ?? '') ?? 0,
      status: json['status'],
    );
  }
}
