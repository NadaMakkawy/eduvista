import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/course/course_bloc.dart';
import '../../models/course.dart';

import 'course_cards_List_widget.dart';

class ClickedCoursesWidget extends StatelessWidget {
  final List<String> clickedCourseIds;

  const ClickedCoursesWidget({Key? key, required this.clickedCourseIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var futureCall = context.read<CourseBloc>().fetchCourses(clickedCourseIds);

    return FutureBuilder<List<Course>>(
      future: futureCall,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error occurred'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Courses available'));
        }

        return CourseCardsListWidget(
          courses: snapshot.data!,
          useFixedCrossAxisCount: true,
        );
      },
    );
  }
}
