import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
  });

  final String title;
  final IconData icon;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 160,
        width: 300,
        decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          color: color.onPrimary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 90,
              color: color.primary,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
