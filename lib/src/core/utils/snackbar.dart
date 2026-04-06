import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/utils/app_top_snackbar.dart';

void showSnackBar(GlobalKey<NavigatorState> navKey, String message) {
  showAppTopSnackBar(navKey, message);
}
