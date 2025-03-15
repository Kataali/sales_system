import 'package:sales_system/core/constants/image_constants.dart';
import 'package:sales_system/models/product/product.dart';

class MockData {
  static const List<Product> mockProducts = [
    Product(
        imgUrl: ImageAssets.chicken,
        name: "Sausage",
        price: 15.00,
        category: "Sausage",
        size: "Large",
        quantity: 15,
        id: 3456789987654),
    Product(
        imgUrl: ImageAssets.fish,
        name: "Fish",
        price: 15.00,
        category: "Fish",
        size: "Small",
        id: 23456789087654,
        quantity: 15),
    Product(
        imgUrl: ImageAssets.chicken,
        name: "Chicken",
        price: 15.00,
        category: "Chiken",
        size: "Medium",
        id: 345678987654,
        quantity: 15),
    Product(
        imgUrl: ImageAssets.beef,
        name: "Sausage",
        price: 15.00,
        category: "Sausage",
        size: "Large",
        id: 4567898765,
        quantity: 15),
    Product(
      imgUrl: ImageAssets.fish,
      name: "Fish",
      price: 15.00,
      category: "Fish",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
    Product(
      imgUrl: ImageAssets.chicken,
      name: "Chicken",
      price: 15.00,
      category: "Chiken",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
  ];

  static List<Product> mockCartProducts = [
    const Product(
      imgUrl: ImageAssets.chicken,
      name: "Sausage",
      price: 15.00,
      category: "Sausage",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
    const Product(
      imgUrl: ImageAssets.fish,
      name: "Fish",
      price: 15.00,
      category: "Fish",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
    const Product(
      imgUrl: ImageAssets.chicken,
      name: "Chicken",
      price: 15.00,
      category: "Chiken",
      size: "Large",
      id: 4567898765,
      quantity: 15,
    ),
  ];
}