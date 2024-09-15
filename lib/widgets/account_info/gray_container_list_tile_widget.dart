import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class GrayContainerListTileWidget extends StatelessWidget {
  final String label;
  void Function()? onTap;

  GrayContainerListTileWidget({
    required this.onTap,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtility.grayExtraLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_double_arrow_right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
