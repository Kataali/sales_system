import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/cart/data/models/checkout_result_model.dart';

class CartRemoteDatasource {
  final String baseUrl = ApiConstants.baseUrl;
  final AuthSecureStorage storage;

  CartRemoteDatasource(this.storage);

  Future<CheckoutResult> checkout({
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

    final body = jsonDecode(response.body);

    if (response.statusCode == 201 && body['success'] == true) {
      return CheckoutResult.fromJson(body);
    } else {
      throw Exception(body['error']['message'] ?? "Checkout failed");
    }
  }
}
