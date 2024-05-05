class ProductsModel {
  final String name;
  final double price;
  final String imgUrl;
  final String size;
  final String category;

  ProductsModel(
      {required this.size,
      required this.name,
      required this.price,
      required this.imgUrl,
      required this.category});
}
