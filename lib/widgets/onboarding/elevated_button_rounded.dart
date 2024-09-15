import 'package:flutter/material.dart';

class ElevatedButtonRounded extends StatelessWidget {
  void Function()? onPressed;
  Color? backgroundColor;
  Widget? icon;

  ElevatedButtonRounded(
      {required this.onPressed,
      required this.icon,
      required this.backgroundColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(65, 65),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(15),
        shape: const CircleBorder(),
        backgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: icon,
    );
  }
}
