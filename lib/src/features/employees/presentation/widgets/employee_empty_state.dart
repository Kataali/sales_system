import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class EmployeeEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmployeeEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ExtraColors.link.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ExtraColors.link, size: 32),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ExtraColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ExtraColors.darkGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
