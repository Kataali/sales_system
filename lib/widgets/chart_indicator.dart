import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator(
      {super.key,
      required this.color,
      required this.title,
      required this.spaceOccupied});
  final Color color;
  final String title;
  final int spaceOccupied;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: ShapeDecoration(
            color: color,
            shape: const CircleBorder(side: BorderSide.none),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "$spaceOccupied%",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }
}
