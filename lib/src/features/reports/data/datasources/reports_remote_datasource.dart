import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sales_system/src/core/constants/api_constants.dart';
import 'package:sales_system/src/features/authentication/datasources/datasources/token_storage.dart';
import 'package:sales_system/src/features/reports/domain/entities/report_entity.dart';

class ReportsRemoteDataSource {
  final AuthSecureStorage storage;
  final String baseUrl = ApiConstants.baseUrl;

  ReportsRemoteDataSource(this.storage);

  Future<Map<String, dynamic>> fetchRevenueReport(
    String token, {
    required ReportPeriod period,
    DateTime? customDate,
  }) async {
    final queryParameters = <String, String>{
      'period': period.param,
      if (period == ReportPeriod.custom && customDate != null)
        'date': DateFormat('yyyy-MM-dd').format(customDate),
    };

    final uri = Uri.parse('$baseUrl${Endpoints.revenueReport}')
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        return body;
      }
      throw Exception('Invalid report response.');
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Unauthorized access to report data.');
    }

    throw Exception(
        'Failed to load revenue report (status ${response.statusCode}).');
  }
}
