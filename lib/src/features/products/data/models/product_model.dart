import 'dart:convert';
import '../../domain/entities/product.dart';

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
    List<ProductVariant> variants = [];
    final rawVariants = json['variants'];

    if (rawVariants is List) {
      variants = rawVariants.map((v) {
        if (v is Map) {
          final map = Map<String, dynamic>.from(v);
          return ProductVariant(
            size: map['size']?.toString() ?? '',
            price: (map['price'] as num?)?.toDouble() ?? 0.0,
            stock: (map['stock'] as num?)?.toInt() ?? 0,
          );
        }
        return ProductVariant(size: '', price: 0.0, stock: 0);
      }).toList();
    } else if (rawVariants is String && rawVariants.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawVariants);
        if (decoded is List) {
          variants = decoded.map((v) {
            final map = Map<String, dynamic>.from(v as Map);
            return ProductVariant(
              size: map['size']?.toString() ?? '',
              price: (map['price'] as num?)?.toDouble() ?? 0.0,
              stock: (map['stock'] as num?)?.toInt() ?? 0,
            );
          }).toList();
        }
      } catch (_) {}
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
      variants: variants,
      totalStock: computedStock,
    );
  }
}
