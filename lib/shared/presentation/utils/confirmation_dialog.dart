import 'package:fluent_ui/fluent_ui.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

/// Dialog types for different purposes
enum DialogType { confirmation, warning, info, success, error }

/// A reusable, flexible dialog widget using Fluent UI.
Future<bool?> showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  DialogType type = DialogType.confirmation,
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
}) {
  IconData dialogIcon;
  Color iconColor;

  switch (type) {
    case DialogType.confirmation:
      dialogIcon = FluentIcons.help;
      iconColor = ExtraColors.emerald;
      break;
    case DialogType.warning:
      dialogIcon = FluentIcons.warning;
      iconColor = ExtraColors.crimson;
      break;
    case DialogType.info:
      dialogIcon = FluentIcons.info;
      iconColor = Colors.blue;
      break;
    case DialogType.success:
      dialogIcon = FluentIcons.completed;
      iconColor = ExtraColors.emerald;
      break;
    case DialogType.error:
      dialogIcon = FluentIcons.error;
      iconColor = ExtraColors.crimson;
      break;
  }

  final showCancel = type == DialogType.confirmation || type == DialogType.warning;

  return showDialog<bool>(
    context: context,
    builder: (context) => ContentDialog(
      title: Row(
        children: [
          Icon(dialogIcon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Text(title),
        ],
      ),
      content: Text(content),
      actions: [
        if (showCancel)
          Button(
            child: Text(cancelText),
            onPressed: () => Navigator.pop(context, false),
          ),
        FilledButton(
          child: Text(confirmText),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}
