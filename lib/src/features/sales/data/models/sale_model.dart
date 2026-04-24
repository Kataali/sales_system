import 'package:sales_system/src/features/sales/domain/entities/sale_entity.dart';

class SaleModel extends SaleEntity {
  SaleModel({
    required super.id,
    required super.userId,
    required super.totalAmount,
    required super.status,
    super.depositId,
    super.isCollected,
    super.collectedAt,
    super.customerName,
    super.customerPhone,
    super.userName,
    super.items,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      totalAmount:
          double.tryParse(json['totalAmount']?.toString() ?? '') ?? 0.0,
      status: json['status'] ?? 'completed',
      depositId: json['depositId'],
      isCollected: json['isCollected'] ?? true,
      collectedAt: json['collectedAt'] != null
          ? DateTime.tryParse(json['collectedAt'].toString())
          : null,
      customerName: json['customerName']?.toString(),
      customerPhone: json['customerPhone']?.toString(),
      userName: json['User']?['name']?.toString(),
      items: ((json['SaleItems'] as List<dynamic>?) ?? const [])
          .map((item) => SaleItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'status': status,
      'depositId': depositId,
      'isCollected': isCollected,
      'collectedAt': collectedAt?.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'userName': userName,
      'items': items.map((item) => SaleItemModel.fromEntity(item).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SaleItemModel extends SaleItemEntity {
  SaleItemModel({
    required super.id,
    required super.saleId,
    required super.productId,
    required super.quantity,
    required super.selectedSize,
    required super.unitPrice,
    required super.totalAmount,
    required super.status,
    super.productName,
    super.productSku,
    required super.createdAt,
    super.updatedAt,
  });

  factory SaleItemModel.fromEntity(SaleItemEntity entity) {
    return SaleItemModel(
      id: entity.id,
      saleId: entity.saleId,
      productId: entity.productId,
      quantity: entity.quantity,
      selectedSize: entity.selectedSize,
      unitPrice: entity.unitPrice,
      totalAmount: entity.totalAmount,
      status: entity.status,
      productName: entity.productName,
      productSku: entity.productSku,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      id: json['id'] ?? 0,
      saleId: json['saleId'] ?? 0,
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'] ?? 'N/A',
      unitPrice: double.tryParse(json['unitPrice']?.toString() ?? '') ?? 0.0,
      totalAmount:
          double.tryParse(json['totalAmount']?.toString() ?? '') ?? 0.0,
      status: json['status'] ?? 'completed',
      productName: json['Product']?['name']?.toString(),
      productSku: json['Product']?['sku']?.toString(),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saleId': saleId,
      'productId': productId,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'status': status,
      'productName': productName,
      'productSku': productSku,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
