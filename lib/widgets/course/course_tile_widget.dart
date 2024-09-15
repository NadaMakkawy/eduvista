import 'package:eduvista/models/course.dart';
import 'package:eduvista/widgets/course/rating_display_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class CourseTileWidget extends StatelessWidget {
  CourseTileWidget({
    super.key,
    required this.course,
    required this.showExtraInfo,
  });

  final Course course;
  final bool showExtraInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                course.image ?? 'https://via.placeholder.com/150',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 20),
          FittedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  course.title ?? 'No Title',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person_outline_outlined),
                    SizedBox(width: 8),
                    Text(
                      course.instructor?.name ?? 'No Instructor',
                    ),
                  ],
                ),
                if (showExtraInfo) ...[
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        course.rating.toString(),
                        style:
                            TextStyle(fontSize: 16, color: ColorUtility.gray),
                      ),
                      SizedBox(width: 5),
                      RatingDisplay(rating: course.rating!),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${course.price?.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorUtility.main,
                      fontSize: 20,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
