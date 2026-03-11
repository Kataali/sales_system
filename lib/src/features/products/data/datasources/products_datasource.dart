import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/data/datasources/token_storage.dart';
import '../models/product_model.dart';

class ProductsRemoteDatasource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  ProductsRemoteDatasource({required this.storage});

  Future<List<ProductModel>> getProducts() async {
    final token = await storage.getAccessToken();

    await Future.delayed(const Duration(seconds: 3)); // Simulate network delay

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.products}");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      print(jsonList);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products: ${response.body}");
    }
  }
}
