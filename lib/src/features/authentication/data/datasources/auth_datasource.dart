import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sales_system/src/core/constants/api_constants.dart';

class AuthRemoteDatasource {
  final String baseUrl = ApiConstants.baseUrl;

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    final url = Uri.parse("$baseUrl${Endpoints.login}");

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
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // final token = json['token'];
      // return UserModel.fromJson(json['user']);
      return json;
    } else {
      throw Exception("Login failed: ${json['error']['message']}");
    }
  }
}
