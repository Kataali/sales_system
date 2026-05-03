import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
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
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList =
          jsonResponse['products']; // Adjust the key based on the API response
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products: ${response.body}");
    }
  }

  Future<void> createProduct({
    required String name,
    Uint8List? imageBytes,
    String? imageName,
    required String sku,
    required List<Map<String, dynamic>> variants,
    required int totalStock,
  }) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.products}");
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['sku'] = sku
      ..fields['totalStock'] = totalStock.toString()
      ..fields['variants'] = jsonEncode(variants);

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'imageUrl',
          imageBytes,
          filename: (imageName != null && imageName.trim().isNotEmpty)
              ? imageName.trim()
              : 'product-image.jpg',
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to create product: ${response.body}");
    }
  }
}
