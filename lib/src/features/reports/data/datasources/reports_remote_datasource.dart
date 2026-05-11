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
        final success = body['success'];
        if (success == false) {
          throw Exception(body['message']?.toString() ?? 'Failed to load report.');
        }

        final report = body['report'];
        if (report is Map || body.containsKey('date')) {
          return body;
        }

        throw Exception('Invalid report payload: missing "report".');
      }
      if (body is Map) {
        final normalized = body.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        final success = normalized['success'];
        if (success == false) {
          throw Exception(
              normalized['message']?.toString() ?? 'Failed to load report.');
        }
        if (normalized['report'] is Map || normalized.containsKey('date')) {
          return normalized;
        }
        throw Exception('Invalid report payload: missing "report".');
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
