import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/viewed.png', height: 400, width: 400,),
        Text(
          "OOps!! Nothing to Show Here",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: color.onTertiary),
        )
      ],
    );
  }
}
