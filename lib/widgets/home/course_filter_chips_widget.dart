import 'package:flutter/material.dart';

import '../../utils/color_utilis.dart';

class CourseFilterChipsWidget extends StatelessWidget {
  const CourseFilterChipsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 5, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtility.grayExtraLight,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'All',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
