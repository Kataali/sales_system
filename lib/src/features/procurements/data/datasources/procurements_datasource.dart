import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/procurements/data/models/procurement_model.dart';

class ProcurementsRemoteDatasource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  ProcurementsRemoteDatasource({required this.storage});

  Future<List<ProcurementModel>> fetchProcurements({
    int page = 1,
    int limit = 50,
  }) async {
    final token = await storage.getAccessToken();
    if (token == null) throw Exception("No auth token found");

    final uri = Uri.parse("$baseUrl${Endpoints.procurements}").replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final procurements =
          (jsonResponse['procurements'] as List<dynamic>? ?? const [])
              .map(
                (item) =>
                    ProcurementModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
      return procurements;
    }

    throw Exception("Failed to fetch procurements: ${response.body}");
  }

  Future<ProcurementModel> fetchProcurementById(int id) async {
    final token = await storage.getAccessToken();
    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.procurementById(id.toString())}");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return ProcurementModel.fromJson(
        jsonResponse['procurement'] as Map<String, dynamic>,
      );
    }

    throw Exception("Failed to fetch procurement: ${response.body}");
  }

  Future<ProcurementModel> createProcurement({
    String? supplierName,
    String? referenceNumber,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await storage.getAccessToken();
    if (token == null) throw Exception("No auth token found");

    final url = Uri.parse("$baseUrl${Endpoints.procurements}");
    final body = {
      'supplierName': supplierName,
      'referenceNumber': referenceNumber,
      'items': items,
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
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return ProcurementModel.fromJson(
        jsonResponse['procurement'] as Map<String, dynamic>,
      );
    }

    throw Exception("Failed to create procurement: ${response.body}");
  }
}
