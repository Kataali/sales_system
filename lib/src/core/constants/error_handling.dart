import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_system/shared/error/server_exception.dart';
import 'package:sales_system/src/core/utils/snackbar.dart';

/// Parses [response] using [ServerException.fromJson] and shows the result
/// as a snack-bar, or calls [onSuccess] on HTTP 200/201.
void handleHttpError(
    {required http.Response response,
    required GlobalKey<NavigatorState> navKey,
    required VoidCallback onSuccess}) {
  final status = response.statusCode;
  if (status == 200 || status == 201) {
    onSuccess();
    return;
  }

  String message;
  try {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final exception = ServerException.fromJson(json, status);
    message = exception.message;
  } catch (_) {
    message = response.body.isNotEmpty ? response.body : 'Unknown error ($status)';
  }

  showSnackBar(navKey, message);
}
