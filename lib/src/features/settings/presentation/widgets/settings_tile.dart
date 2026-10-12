import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_iconly_plus/flutter_iconly_plus.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isDestructive;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? ExtraColors.crimson : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? ExtraColors.crimson : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(color: ExtraColors.darkGrey, fontSize: 12),
            )
          : null,
      trailing: const Icon(IconlyLight.arrow_right_2, size: 16),
      onPressed: onTap,
    );
  }
}
