import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class CustomTextButton extends StatelessWidget {
  String label;
  void Function()? onPressed;
  CustomTextButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Text(
            label,
            style:
                const TextStyle(color: ColorUtility.deepYellow, fontSize: 15),
          ),
        ));
  }
}
