class Product {
  final String imgUrl;
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String category;
  final String size;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    required this.size,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
      'size': size,
    };
  }
}
