import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String imagePath;
  final double imageSize;

  const EmptyScreen({
    super.key,
    this.title = 'Oops!! Nothing to Show Here',
    this.subtitle,
    this.imagePath = 'assets/viewed.png',
    this.imageSize = 220,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: imageSize,
              width: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.inbox_rounded,
                size: imageSize * 0.5,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
