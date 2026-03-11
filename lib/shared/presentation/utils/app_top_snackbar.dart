import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

/// Shows a top snackbar with a given message and type.
/// [type] can be 'success', 'error', or 'info'.
void showAppTopSnackBar(GlobalKey<NavigatorState> navKey, String message, {String type = 'success'}) {
  final overlay =
      navKey.currentState?.overlay; // Get the overlay directly from the key
  if (overlay == null) return;
  Widget snackBar;
  switch (type) {
    case 'error':
      snackBar = CustomSnackBar.error(message: message);
      break;
    case 'info':
      snackBar = CustomSnackBar.info(message: message);
      break;
    case 'success':
    default:
      snackBar = CustomSnackBar.success(message: message);
      break;
  }
  showTopSnackBar(overlay, snackBar);
}
