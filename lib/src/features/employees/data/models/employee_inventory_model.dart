import 'package:sales_system/src/features/employees/domain/entities/employee_inventory_item.dart';

class EmployeeInventoryItemModel extends EmployeeInventoryItem {
  const EmployeeInventoryItemModel({
    required super.productId,
    required super.productName,
    required super.status,
    required super.variant,
  });

  factory EmployeeInventoryItemModel.fromJson(Map<String, dynamic> json) {
    return EmployeeInventoryItemModel(
      productId: int.tryParse(json['productId']?.toString() ?? '') ?? 0,
      productName: json['productName']?.toString() ?? 'Unknown Product',
      status: json['status']?.toString() ?? 'unknown',
      variant: EmployeeInventoryVariantModel.fromJson(
        json['variant'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}

class EmployeeInventoryVariantModel extends EmployeeInventoryVariant {
  const EmployeeInventoryVariantModel({
    required super.size,
    required super.price,
    required super.stock,
    required super.costPrice,
    required super.lowStockThreshold,
  });

  factory EmployeeInventoryVariantModel.fromJson(Map<String, dynamic> json) {
    return EmployeeInventoryVariantModel(
      size: json['size']?.toString() ?? 'N/A',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      costPrice: double.tryParse(json['costPrice']?.toString() ?? '') ?? 0,
      lowStockThreshold:
          int.tryParse(json['lowStockThreshold']?.toString() ?? '') ?? 0,
    );
  }
}
