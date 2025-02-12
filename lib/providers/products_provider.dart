import 'package:flutter/foundation.dart';
import 'package:sales_system/models/product/product.dart';

import '../core/constants/mock_products.dart';
// import 'package:sales_system/models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> currentProducts = mockProducts;

  List<Product> checkedoutProducts = [
    const Product(
      imgUrl: 'assets/sausages.jpg',
      name: "Sausage",
      price: 15.00,
      category: "Sausage",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
    const Product(
      imgUrl: 'assets/frozen-fish.jpg',
      name: "Fish",
      price: 15.00,
      category: "Fish",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
    const Product(
      imgUrl: 'assets/full-chicken.jpg',
      name: "Chicken",
      price: 15.00,
      category: "Chiken",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
  ];

  void addProduct(Product product) {
    currentProducts.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    currentProducts.remove(product);
    notifyListeners();
  }

  void addCheckedoutProduct(Product product) {
    checkedoutProducts.add(product);
    notifyListeners();
  }

  void removeCheckedoutProduct(Product product) {
    checkedoutProducts.remove(product);
    notifyListeners();
  }

  int get checkedoutProductsLength => checkedoutProducts.length;
  Product getCheckedoutProductByIndex(int index) => checkedoutProducts[index];
  // void editTask(productsModel product, String name) {
  //   product.name = name;
  //   notifyListeners();
  // }

  int get productsLength => currentProducts.length;
  Product getProductByIndex(int index) => currentProducts[index];
}
