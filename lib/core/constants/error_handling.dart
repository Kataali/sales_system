// From the server, it is possible that some responses won't necessarry throw errors
// but will rather be sent with a 500 or 400 status message. Since these arent errors
// that can be caught in the normal try-catch blocks, we need a way to handle them
// Thus the need for this snippet
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_system/core/utils/snackbar.dart';

void handleHttpError(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['message']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
