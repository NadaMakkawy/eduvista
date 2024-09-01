import 'package:flutter/material.dart';

class ElevatedButtonRounded extends StatelessWidget {
  void Function()? onPressed;
  WidgetStateProperty<Color?>? backgroundColor;
  Widget? icon;

  ElevatedButtonRounded(
      {required this.onPressed,
      required this.icon,
      required this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(const Size(65, 65)),
        foregroundColor: WidgetStateProperty.all<Color>(
          Colors.white,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.all(15),
        ),
        shape: WidgetStateProperty.all<CircleBorder>(const CircleBorder()),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: icon,
    );
  }
}
