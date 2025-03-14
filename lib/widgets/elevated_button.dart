import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      this.leading,
      required this.buttonText,
      required this.onPressed});
  final Widget? leading;
  final String buttonText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: color.onSecondary,
        foregroundColor: color.secondary,
      ),
      child: Row(
        children: [
          leading!,
          Text(buttonText),
        ],
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
