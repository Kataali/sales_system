import 'package:flutter/foundation.dart';
import 'package:sales_system/core/constants/mock_cart_products.dart';
import 'package:sales_system/models/product/product.dart';

class CartProvider extends ChangeNotifier {
  // Items Added to the cart
  List checkedoutProducts = mockCartProducts;
  // Total of the items
  double get total => getTotal();

  double getTotal() {
    final products = checkedoutProducts;
    double total = 0;
    if (checkedoutProductsLength > 0) {
      for (var product in products) {
        total += product.price!;
      }
      return total;
    }
    return 0;
  }

  // Add product to cart
  void addToCart(Product product) {
    checkedoutProducts.add(product);
    getTotal();
    notifyListeners();
  }

  // Remove product from cart
  void removeCheckedoutProduct(Product product) {
    checkedoutProducts.remove(product);
    getTotal();
    notifyListeners();
  }

  // Notify listeners of an action
  void alertListeners() {
    notifyListeners();
  }

  // clear cart
  void clearCart() {
    checkedoutProducts.clear();
    getTotal();
    notifyListeners();
  }

  int get checkedoutProductsLength => checkedoutProducts.length;
  Product getCheckedoutProductByIndex(int index) => checkedoutProducts[index];
  // void editTask(productsModel product, String name) {
  //   product.name = name;
  //   notifyListeners();
  //
}
