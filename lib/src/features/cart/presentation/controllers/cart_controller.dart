import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sales_system/src/features/cart/data/models/checkout_result_model.dart';
import 'package:sales_system/src/features/cart/domain/entities/cart.dart';
import 'package:sales_system/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:sales_system/src/features/products/domain/entities/product.dart';

class CartController extends StateNotifier<AsyncValue<List<CartItem>>> {
  final CartRepository repository;

  CartController(this.repository) : super(const AsyncValue.data([]));

  void addItem(Product product, ProductVariant variant) {
    final List<CartItem> items = [...state.value ?? []];

    final index = items.indexWhere(
      (item) =>
          item.product.id == product.id && item.variant.size == variant.size,
    );

    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(
        CartItem(
          product: product,
          variant: variant,
          quantity: 1,
        ),
      );
    }

    state = AsyncValue.data(items);
  }

  void removeItem(CartItem item) {
    final List<CartItem> items = [...state.value ?? []];
    items.remove(item);
    state = AsyncValue.data(items);
  }

  void updateQuantity(CartItem item, int quantity) {
    final List<CartItem> items = [...state.value ?? []];

    final index = items.indexWhere(
      (i) =>
          i.product.id == item.product.id &&
          i.variant.size == item.variant.size,
    );

    if (index == -1) return;

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index].quantity = quantity;
    }

    state = AsyncValue.data(items);
  }

  Future<CheckoutResult> checkout({
    bool isCollected = true,
    String? customerName,
    String? customerPhone,
  }) async {
    final List<CartItem> items =
        state.value ?? []; // Get items BEFORE setting to loading

    try {
      state = const AsyncValue.loading();

      final result = await repository.checkout(
        items,
        isCollected: isCollected,
        customerName: customerName,
        customerPhone: customerPhone,
      );

      state = const AsyncValue.data([]); // Clear cart on success

      return result;
    } catch (e) {
      state = AsyncValue.data(items);
      rethrow;
    }
  }
}
