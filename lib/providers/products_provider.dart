import 'package:flutter/foundation.dart';
import 'package:sales_system/models/productModel.dart';

class ProductsProvider extends ChangeNotifier {
  List<ProductsModel> currentProducts = [
    ProductsModel(
      imgUrl: 'assets/sausages.jpg',
      name: "Sausage",
      price: 15.00,
      category: "Sausage",
      size: "Large",
    ),
    ProductsModel(
        imgUrl: 'assets/frozen-fish.jpg',
        name: "Fish",
        price: 15.00,
        category: "Fish",
        size: "Small"),
    ProductsModel(
      imgUrl: 'assets/full-chicken.jpg',
      name: "Chicken",
      price: 15.00,
      category: "Chiken",
      size: "Medium",
    ),
    ProductsModel(
      imgUrl: 'assets/sausages.jpg',
      name: "Sausage",
      price: 15.00,
      category: "Sausage",
      size: "Large",
    ),
    ProductsModel(
      imgUrl: 'assets/frozen-fish.jpg',
      name: "Fish",
      price: 15.00,
      category: "Fish",
      size: "Large",
    ),
    ProductsModel(
        imgUrl: 'assets/full-chicken.jpg',
        name: "Chicken",
        price: 15.00,
        category: "Chiken",
        size: "Large"),
  ];

  List<ProductsModel> checkedoutProducts = [
    ProductsModel(
      imgUrl: 'assets/sausages.jpg',
      name: "Sausage",
      price: 15.00,
      category: "Sausage",
      size: "Large",
    ),
    ProductsModel(
      imgUrl: 'assets/frozen-fish.jpg',
      name: "Fish",
      price: 15.00,
      category: "Fish",
      size: "Large",
    ),
    ProductsModel(
        imgUrl: 'assets/full-chicken.jpg',
        name: "Chicken",
        price: 15.00,
        category: "Chiken",
        size: "Large"),
  ];

  void addProduct(ProductsModel product) {
    currentProducts.add(product);
    notifyListeners();
  }

  void removeProduct(ProductsModel product) {
    currentProducts.remove(product);
    notifyListeners();
  }

  void addCheckedoutProduct(ProductsModel product) {
    checkedoutProducts.add(product);
    notifyListeners();
  }

  void removeCheckedoutProduct(ProductsModel product) {
    checkedoutProducts.remove(product);
    notifyListeners();
  }

  int get checkedoutProductsLength => checkedoutProducts.length;
  ProductsModel getCheckedoutProductByIndex(int index) =>
      checkedoutProducts[index];
  // void editTask(productsModel product, String name) {
  //   product.name = name;
  //   notifyListeners();
  // }

  int get productsLength => currentProducts.length;
  ProductsModel getProductByIndex(int index) => currentProducts[index];
}
