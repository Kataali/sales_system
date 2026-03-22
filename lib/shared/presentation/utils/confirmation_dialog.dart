import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

/// Dialog types for different purposes
enum DialogType { confirmation, warning, info, success, error }

/// A reusable, flexible dialog widget.
/// - Returns `true` if confirmed (for confirmation type), null otherwise.
/// - Automatically adapts icon and colors based on type.
Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  DialogType type = DialogType.confirmation,
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
}) {
  // Determine icon and color based on type
  Icon dialogIcon;
  Color confirmColor;
  Color cancelColor = ExtraColors.crimson;

  switch (type) {
    case DialogType.confirmation:
      dialogIcon =
          const Icon(Icons.help_outline, color: ExtraColors.emerald, size: 40);
      confirmColor = ExtraColors.emerald.withValues(alpha: 0.7);
      break;
    case DialogType.warning:
      dialogIcon =
          const Icon(Icons.warning, color: ExtraColors.crimson, size: 40);
      confirmColor = ExtraColors.crimson;
      break;
    case DialogType.info:
      dialogIcon = const Icon(Icons.info_outline, color: Colors.blue, size: 40);
      confirmColor = Colors.blue.withOpacity(0.7);
      break;
    case DialogType.success:
      dialogIcon =
          const Icon(Icons.check_circle, color: ExtraColors.emerald, size: 40);
      confirmColor = ExtraColors.emerald.withValues(alpha: 0.7);
      break;
    case DialogType.error:
      dialogIcon =
          const Icon(Icons.error, color: ExtraColors.crimson, size: 40);
      confirmColor = ExtraColors.crimson;
      break;
  }

  // Determine whether to show cancel button
  final showCancel =
      type == DialogType.confirmation || type == DialogType.warning;

  return showDialog<bool>(
    context: context,
    barrierDismissible:
        type != DialogType.confirmation && type != DialogType.warning,
    builder: (context) => AlertDialog(
      icon: dialogIcon,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: ExtraColors.black),
      ),
      content: Text(
        content,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: ExtraColors.black),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        if (showCancel)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              elevation: 5,
              backgroundColor: cancelColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              cancelText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ExtraColors.black),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(type == DialogType.confirmation ? true : null),
          style: TextButton.styleFrom(
            elevation: 5,
            backgroundColor: confirmColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            confirmText,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ExtraColors.black),
          ),
        ),
      ],
    ),
  );
}
