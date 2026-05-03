import 'package:sales_system/src/features/cart/data/models/checkout_result_model.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<CheckoutResult> checkout(
    List<CartItem> items, {
    bool isCollected = true,
    String? customerName,
    String? customerPhone,
  });
}
