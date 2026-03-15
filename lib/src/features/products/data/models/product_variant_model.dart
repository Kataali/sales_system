import 'package:sales_system/src/features/products/domain/entities/product.dart';
class ProductVariantModel extends ProductVariant {
  ProductVariantModel({
    required super.size,
    required super.price,
    required super.stock,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      size: json['size'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() => {
        "size": size,
        "price": price,
        "stock": stock,
      };
}
