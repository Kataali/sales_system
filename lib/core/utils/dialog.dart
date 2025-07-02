import 'package:flutter/material.dart';

class CustomDialog {
  final String title;
  final String content;
  final String firstButtonText;
  final String? secondButtonText;
  final Function() onPressFirstButton;
  final Function()? onPressSecondButton;

  CustomDialog(
      {required this.title,
      required this.content,
      this.firstButtonText = "proceed",
      this.secondButtonText = "Cancel",
      required this.onPressFirstButton,
      this.onPressSecondButton});

  static showPopUp(
    BuildContext context,
    String title,
    String content,
    String firstButtonText,
    String? secondButtonText,
    Function() onPressFirstButton,
    Function()? onPressSecondButton,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          final color = Theme.of(context).colorScheme;
          return AlertDialog.adaptive(
            title: Text(
              title,
              style: TextStyle(color: color.secondary),
            ),
            content: Text(
              content,
              style: TextStyle(color: color.secondary),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              TextButton(
                onPressed: () {
                  onPressFirstButton();
                },
                child: Text(firstButtonText.toUpperCase()),
              ),
              secondButtonText != null
                  ? TextButton(
                      onPressed: () {
                        onPressSecondButton!();
                      },
                      child: Text(
                        secondButtonText.toUpperCase(),
                        style: TextStyle(color: color.onTertiary),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        });
  }
}
