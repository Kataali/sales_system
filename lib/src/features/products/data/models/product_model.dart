import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required int id,
    required String name,
    required String imageUrl,
    required String sku,
    required List<ProductVariant> variants,
    required int totalStock,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          sku: sku,
          variants: variants,
          totalStock: totalStock,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final variantsJson = json['variants'] as List<dynamic>;
    final variants = variantsJson
        .map((v) => ProductVariant(
              size: v['size'],
              price: (v['price'] as num).toDouble(),
              stock: v['stock'],
            ))
        .toList();

    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      sku: json['sku'],
      variants: variants,
      totalStock: json['totalStock'],
    );
  }
}
