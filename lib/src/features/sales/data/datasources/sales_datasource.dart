import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/sales/data/models/sale_model.dart';

class SalesRemoteDatasource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  SalesRemoteDatasource({required this.storage});

  Future<List<SaleModel>> fetchSales() async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.sales}");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final salesJson = (jsonResponse['sales'] as List<dynamic>? ?? const []);
      return salesJson
          .map((sale) => SaleModel.fromJson(sale as Map<String, dynamic>))
          .toList();
    }

    throw Exception("Failed to fetch sales: ${response.body}");
  }
}
