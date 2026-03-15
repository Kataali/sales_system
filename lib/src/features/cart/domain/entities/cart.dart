import 'package:sales_system/src/features/products/domain/entities/product.dart';

class CartItem {
  final Product product;
  final ProductVariant variant;
  int quantity;

  CartItem({
    required this.product,
    required this.variant,
    this.quantity = 1,
  });

  double get totalPrice => quantity * variant.price;
}
