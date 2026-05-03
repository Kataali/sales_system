import 'package:sales_system/src/features/cart/data/datasources/cart_datasource.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/cart/data/models/checkout_result_model.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource datasource;
  final AuthSecureStorage storage;

  CartRepositoryImpl(this.datasource, this.storage);

  @override
  Future<CheckoutResult> checkout(
    List<CartItem> items, {
    bool isCollected = true,
    String? customerName,
    String? customerPhone,
  }) async {
    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Please log in again before making a sale.');
    }

    final trimmedCustomerName = customerName?.trim();
    final trimmedCustomerPhone = customerPhone?.trim();

    if (!isCollected &&
        ((trimmedCustomerName == null || trimmedCustomerName.isEmpty) ||
            (trimmedCustomerPhone == null || trimmedCustomerPhone.isEmpty))) {
      throw Exception(
        'Customer name and phone are required for pending pick-ups.',
      );
    }

    final payload = items.map((item) {
      return {
        "productId": item.product.id,
        "selectedSize": item.variant.size,
        // "price": item.variant.price,
        "quantity": item.quantity,
      };
    }).toList();

    return await datasource.checkout(
      token: token,
      items: payload,
      isCollected: isCollected,
      customerName:
          trimmedCustomerName?.isEmpty == true ? null : trimmedCustomerName,
      customerPhone:
          trimmedCustomerPhone?.isEmpty == true ? null : trimmedCustomerPhone,
    );
  }
}
