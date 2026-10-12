import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_system/shared/error/server_exception.dart';
import 'package:sales_system/shared/presentation/connectivity.dart';
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';

class AuthRemoteDatasource {
  final AuthSecureStorage _storage;
  final String _baseUrl = ApiConstants.baseUrl;

  AuthRemoteDatasource(this._storage);

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.getAccessToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.login}");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return json;
    } else {
      throw ServerException.fromJson(json, response.statusCode);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.employees}");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw ServerException.fromJson(json, response.statusCode);
    }
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.employees}");
    final headers = await _getHeaders();

    final response = await http.get(
      url,
      headers: headers,
    );

    final dynamic decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      } else if (decoded is Map<String, dynamic>) {
        final list =
            decoded['employees'] ?? decoded['data'] ?? decoded['results'];
        if (list is List) {
          return list.cast<Map<String, dynamic>>();
        }
      }
      throw ServerException(
        statusCode: 200,
        message: 'Invalid response format: Expected a list of employees.',
      );
    } else {
      final json = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'message': response.body};
      throw ServerException.fromJson(json, response.statusCode);
    }
  }

  Future<void> updateEmployeeStatus(String id, bool isActive) async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.updateEmployeeStatus(id)}");
    final headers = await _getHeaders();

    final response = await http.patch(
      url,
      headers: headers,
      body: jsonEncode({
        "isActive": isActive,
      }),
    );

    if (response.statusCode != 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw ServerException.fromJson(json, response.statusCode);
    }
  }

  Future<Map<String, dynamic>> resetEmployeePassword(String id) async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.resetEmployeePassword(id)}");
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return json;
    } else {
      throw ServerException.fromJson(json, response.statusCode);
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    await guardConnectivity();
    final url = Uri.parse("$_baseUrl${Endpoints.changePassword}");
    final headers = await _getHeaders();

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode != 200) {
      Map<String, dynamic> json;
      try {
        json = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        json = {'message': response.body};
      }
      throw ServerException.fromJson(json, response.statusCode);
    }
  }
}
