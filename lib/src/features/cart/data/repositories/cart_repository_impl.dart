import 'package:sales_system/src/features/cart/data/datasources/cart_datasource.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource datasource;
  final AuthSecureStorage storage;

  CartRepositoryImpl(this.datasource, this.storage);

  @override
  Future<void> checkout(List<CartItem> items) async {
    final token = await storage.getAccessToken();

    final payload = items.map((item) {
      return {
        "productId": item.product.id,
        "selectedSize": item.variant.size,
        // "price": item.variant.price,
        "quantity": item.quantity,
      };
    }).toList();

    await datasource.checkout(
      token: token!,
      items: payload,
    );
  }
}
