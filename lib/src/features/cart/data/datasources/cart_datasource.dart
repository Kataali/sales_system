import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';

class CartRemoteDatasource {
  final String baseUrl = ApiConstants.baseUrl;
  final AuthSecureStorage storage;

  CartRemoteDatasource(this.storage);

  Future<void> checkout({
    required String token,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse("$baseUrl${Endpoints.sales}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "items": items,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Checkout failed: ${response.body}");
    }
  }
}
