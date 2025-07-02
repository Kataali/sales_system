import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      this.leading,
      this.width = double.infinity,
      this.height = 50,
      required this.buttonText,
      required this.onPressed});
  final double width;
  final double height;
  final Widget? leading;
  final String buttonText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: color.onSecondary,
          foregroundColor: color.secondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leading!,
            Text(buttonText),
          ],
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
