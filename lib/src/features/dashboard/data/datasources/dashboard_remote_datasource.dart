import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';

class DashboardRemoteDataSource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  DashboardRemoteDataSource(this.storage);

  Future<Map<String, dynamic>> fetchDashboard(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${Endpoints.dashboard}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Dashboard API Response: ${response.body}'); // Debug log
        return jsonDecode(response.body);
      } 
      else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('You are not authorized to access this resource');
      } 
      else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load dashboard. ${e.toString()}');
    }
  }

}
