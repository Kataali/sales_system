import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import '../models/deposit_model.dart';

class DepositsRemoteDatasource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  DepositsRemoteDatasource({required this.storage});

  Future<List<DepositModel>> getDeposits({
    String? status,
    String? customerName,
    int? page,
    int? limit,
  }) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (customerName != null) queryParams['customerName'] = customerName;
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    final uri = Uri.parse("$baseUrl${Endpoints.deposits}").replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> depositsJson = jsonResponse['deposits'];
      final deposits = depositsJson.map((json) => DepositModel.fromJson(json)).toList();
      return deposits;
    } else {
      throw Exception("Failed to fetch deposits: ${response.body}");
    }
  }

  Future<DepositStatsModel> getDepositStats() async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.depositStats}");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return DepositStatsModel.fromJson(jsonResponse['stats']);
    } else {
      throw Exception("Failed to fetch deposit stats: ${response.body}");
    }
  }

  Future<DepositModel> getDepositById(int id) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.depositById(id.toString())}");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return DepositModel.fromJson(jsonResponse['deposit']);
    } else {
      throw Exception("Failed to fetch deposit: ${response.body}");
    }
  }

  Future<DepositModel> createDeposit({
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required double amount,
    String? description,
    DateTime? expiryDate,
  }) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.deposits}");
    final body = {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'amount': amount,
      'description': description,
      'expiryDate': expiryDate?.toIso8601String(),
    }..removeWhere((key, value) => value == null);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return DepositModel.fromJson(jsonResponse['deposit']);
    } else {
      throw Exception("Failed to create deposit: ${response.body}");
    }
  }

  Future<DepositModel> updateDeposit({
    required int id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    double? amount,
    String? description,
    DateTime? expiryDate,
    String? status,
  }) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.depositById(id.toString())}");
    final body = {
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'amount': amount,
      'description': description,
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status,
    }..removeWhere((key, value) => value == null);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return DepositModel.fromJson(jsonResponse['deposit']);
    } else {
      throw Exception("Failed to update deposit: ${response.body}");
    }
  }

  Future<void> deleteDeposit(int id) async {
    final token = await storage.getAccessToken();

    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.depositById(id.toString())}");
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete deposit: ${response.body}");
    }
  }
}
