class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String sku;
  final List<ProductVariant> variants;
  final int totalStock;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.sku,
    required this.variants,
    required this.totalStock,
  });
}

class ProductVariant {
  final String size;
  final double price;
  final int stock;

  ProductVariant({
    required this.size,
    required this.price,
    required this.stock,
  });
}
