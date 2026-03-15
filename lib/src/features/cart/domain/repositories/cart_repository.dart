import 'package:sales_system/src/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<void> checkout(List<CartItem> items);
}
