import 'package:eduvista/utils/color_utilis.dart';
import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;

  RatingDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating % 1 >= 0.5;

    return Row(
      children: [
        ...List.generate(
            fullStars,
            (index) => Icon(
                  Icons.star,
                  color: ColorUtility.main,
                  size: 16,
                )),
        if (hasHalfStar)
          Icon(
            Icons.star_half,
            color: ColorUtility.main,
            size: 16,
          ),
        ...List.generate(
            5 - fullStars - (hasHalfStar ? 1 : 0),
            (index) => Icon(
                  Icons.star_border,
                  color: ColorUtility.main,
                  size: 16,
                )),
      ],
    );
  }
}
