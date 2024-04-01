import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {super.key,
      required this.title,
      required this.showLeading,
      required this.show});
  final String title;
  final bool showLeading;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      title: Text(title),
      centerTitle: true,
    );
  }
}
