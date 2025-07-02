import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_system/models/product/product.dart';
import 'package:sales_system/providers/cart_provider.dart';
import 'package:sales_system/services/db/db_service.dart';

class ProductsProvider extends ChangeNotifier {
  // List<Product> currentProducts = mockProducts;
  List<Product> currentProducts = [];

  // fetch products from db
  void getProducts() async {
    try {
      currentProducts.clear();
      List jsonProductsList = await DBService.getProducts();
      for (var productJson in jsonProductsList) {
        final Product product = Product.fromJson(productJson);
        currentProducts.add(product);
      }
      notifyListeners();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  // function to filter the Products by type
  void filterProducts(String type) async {
    try {
      if (type == "All") {
        getProducts();
      } else {
        currentProducts.clear();
        List jsonProductsList = await DBService.getProductsByType(type);
        for (var productJson in jsonProductsList) {
          final Product product = Product.fromJson(productJson);
          currentProducts.add(product);
        }
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }
// Filter products based on product categories



  // Add a new product
  void addProduct(Product product) {
    currentProducts.add(product);
    notifyListeners();
  }

  // Remove a product
  void removeProduct(Product product) {
    currentProducts.remove(product);
    notifyListeners();
  }

  //**************************************Getters**********************************
  // get length of currents products
  int get productsLength => currentProducts.length;
  // Get each product by index
  Product getProductByIndex(int index) => currentProducts[index];

  // List get currentPoducts => getProducts();

  void addToCheckout(Product product, BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    cart.addToCart(product);
    notifyListeners();
  }
}
