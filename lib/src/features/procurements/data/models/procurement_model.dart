import 'package:sales_system/src/features/procurements/domain/entities/procurement.dart';

class ProcurementModel extends ProcurementEntity {
  ProcurementModel({
    required super.id,
    super.userId,
    super.supplierName,
    super.referenceNumber,
    required super.totalCost,
    required super.status,
    required super.procuredAt,
    super.userName,
    required super.items,
  });

  factory ProcurementModel.fromJson(Map<String, dynamic> json) {
    return ProcurementModel(
      id: json['id'] ?? 0,
      userId: json['userId'] as int?,
      supplierName: json['supplierName']?.toString(),
      referenceNumber: json['referenceNumber']?.toString(),
      totalCost: _parseDouble(json['totalCost']),
      status: json['status']?.toString() ?? 'completed',
      procuredAt: DateTime.parse(
        json['procuredAt']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      userName: json['User']?['name']?.toString(),
      items: ((json['ProcurementItems'] as List<dynamic>?) ?? const [])
          .map(
            (item) => ProcurementItemModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class ProcurementItemModel extends ProcurementItemEntity {
  ProcurementItemModel({
    required super.id,
    required super.productId,
    super.selectedSize,
    required super.quantity,
    required super.unitCost,
    required super.totalCost,
    super.productName,
    super.productSku,
    super.productImageUrl,
  });

  factory ProcurementItemModel.fromJson(Map<String, dynamic> json) {
    return ProcurementItemModel(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      selectedSize: json['selectedSize']?.toString(),
      quantity: json['quantity'] ?? 0,
      unitCost: _parseDouble(json['unitCost']),
      totalCost: _parseDouble(json['totalCost']),
      productName: json['Product']?['name']?.toString(),
      productSku: json['Product']?['sku']?.toString(),
      productImageUrl: json['Product']?['imageUrl']?.toString(),
    );
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
