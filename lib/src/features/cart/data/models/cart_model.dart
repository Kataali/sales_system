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
    final rawVariants = json['variants'];
    List<ProductVariantModel> variants = [];
    if (rawVariants is List) {
      variants = rawVariants
          .whereType<Map>()
          .map(
              (v) => ProductVariantModel.fromJson(Map<String, dynamic>.from(v)))
          .toList();
    }

    final computedStock = (json['totalStock'] as num?)?.toInt() ??
        variants.fold<int>(0, (sum, v) => sum + v.stock);

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ??
          int.tryParse(json['id']?.toString() ?? '0') ??
          0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      totalStock: computedStock,
      variants: variants,
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
