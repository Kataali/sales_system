import 'package:flutter/material.dart';
import 'package:sales_system/shared/presentation/theme/app_colors.dart';

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
    Color backgroundColor = Theme.of(context).brightness == Brightness.light
        ? ExtraColors.white
        : ExtraColors.darkGrey;
    Color foregroundColor = Theme.of(context).brightness == Brightness.light
        ? ExtraColors.blue
        : ExtraColors.skyBlue;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading != null) leading!,
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
