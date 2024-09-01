import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class OnBoardIndicator extends StatelessWidget {
  final int? positionIndex, currentIndex;
  const OnBoardIndicator({super.key, this.currentIndex, this.positionIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: positionIndex == currentIndex ? 40 : 30,
      decoration: BoxDecoration(
          color: positionIndex == currentIndex
              ? ColorUtility.deepYellow
              : Colors.black,
          borderRadius: BorderRadius.circular(5)),
    );
  }
}
