import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_system/shared/error/server_exception.dart';
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
    bool isCollected = true,
    String? customerName,
    String? customerPhone,
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
        "isCollected": isCollected,
        "customerName": customerName,
        "customerPhone": customerPhone,
      }),
    );

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ServerException(
        statusCode: response.statusCode,
        message: response.body.trim().isEmpty
            ? 'Checkout failed (${response.statusCode})'
            : response.body,
      );
    }

    final isSuccessfulStatus =
        response.statusCode >= 200 && response.statusCode < 300;
    if (isSuccessfulStatus && body['success'] != false) {
      return CheckoutResult.fromJson(body);
    }

    throw ServerException.fromJson(body, response.statusCode);
  }
}
