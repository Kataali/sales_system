import 'package:sales_system/src/features/products/data/models/product_variant_model.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.sku,
    required super.variants,
    required super.totalStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      sku: json['sku'],
      totalStock: json['totalStock'],
      variants: (json['variants'] as List)
          .map((v) => ProductVariantModel.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "sku": sku,
        "totalStock": totalStock,
        "variants":
            variants.map((v) => (v as ProductVariantModel).toJson()).toList(),
      };
}
