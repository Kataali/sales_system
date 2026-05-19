import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_system/shared/error/server_exception.dart';
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/employees/data/models/employee_inventory_model.dart';
import 'package:sales_system/src/features/employees/data/models/employee_summary_model.dart';
import 'package:sales_system/src/features/sales/data/models/sale_model.dart';

class EmployeeRemoteDatasource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  EmployeeRemoteDatasource({required this.storage});

  Future<EmployeeSummaryModel> fetchSummary() async {
    final body = await _get(Endpoints.employeeSummary);
    return EmployeeSummaryModel.fromJson(body);
  }

  Future<List<SaleModel>> fetchSales() async {
    final body = await _get(Endpoints.employeeSales);
    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final salesJson = data['sales'] as List<dynamic>? ?? const [];

    return salesJson
        .whereType<Map<String, dynamic>>()
        .map(SaleModel.fromJson)
        .toList();
  }

  Future<List<EmployeeInventoryItemModel>> fetchInventory() async {
    final body = await _get(Endpoints.employeeInventory);
    final data = body['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final productsJson = data['products'] as List<dynamic>? ?? const [];

    return productsJson
        .whereType<Map<String, dynamic>>()
        .map(EmployeeInventoryItemModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await storage.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Please log in again to continue.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ServerException(
        statusCode: response.statusCode,
        message: response.body.trim().isEmpty
            ? 'Request failed (${response.statusCode})'
            : response.body,
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        body['status'] != 'error') {
      return body;
    }

    throw ServerException.fromJson(body, response.statusCode);
  }
}
