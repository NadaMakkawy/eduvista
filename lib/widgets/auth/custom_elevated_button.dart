import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class CustomElevatedButton extends StatelessWidget {
  void Function() onPressed;
  double? width;
  Color? backgroundColor;
  Color? foregroundColor;
  Widget? child;
  String? text;
  double? horizontal;

  CustomElevatedButton(
      {required this.onPressed,
      this.width,
      this.backgroundColor,
      this.foregroundColor,
      this.child,
      this.text,
      this.horizontal,
      super.key}) {
    assert(
        child != null || text != null, 'child Or Text must not equal to null');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: horizontal ?? 20),
      child: SizedBox(
        width: width,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: ColorUtility.grayLight),
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: backgroundColor ?? ColorUtility.deepYellow,
              foregroundColor: foregroundColor ?? Colors.white,
              surfaceTintColor: Colors.white),
          onPressed: onPressed,
          child: text != null
              ? Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}
