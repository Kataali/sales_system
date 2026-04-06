import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const StepButton({super.key, 
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled ? ExtraColors.link : ExtraColors.darkBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: enabled
                  ? ExtraColors.link
                  : ExtraColors.link.withValues(alpha: 0.4)),
        ),
        child: Icon(icon,
            color: enabled
                ? ExtraColors.white
                : ExtraColors.darkGrey.withValues(alpha: 0.3),
            size: 16),
      ),
    );
  }
}
