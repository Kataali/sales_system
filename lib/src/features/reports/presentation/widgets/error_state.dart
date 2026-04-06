import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

class ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                  color: ExtraColors.crimson.withValues(alpha: 0.08),
                  shape: BoxShape.circle),
              child: const Icon(Icons.error_outline_rounded,
                  color: ExtraColors.crimson, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('Failed to load report',
                style: TextStyle(
                    color: ExtraColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(error,
                style: const TextStyle(
                    color: ExtraColors.darkGrey, fontSize: 12),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: ExtraColors.crimson.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: ExtraColors.crimson.withValues(alpha: 0.3)),
                ),
                child: const Text('Try again',
                    style: TextStyle(
                        color: ExtraColors.crimson,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
