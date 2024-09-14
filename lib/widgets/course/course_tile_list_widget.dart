import 'package:flutter/material.dart';

import '../../models/course.dart';

import '../../widgets/course/course_tile_widget.dart';

import '../../pages/course_details_page.dart';

class CourseTileListWidget extends StatelessWidget {
  const CourseTileListWidget({
    super.key,
    required this.courses,
  });

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          var course = courses[index];

          return InkWell(
              onTap: () => Navigator.pushNamed(context, CourseDetailsPage.id,
                  arguments: course),
              child: CourseTileWidget(
                course: course,
                showExtraInfo: false,
              ));
        },
      ),
    );
  }
}
