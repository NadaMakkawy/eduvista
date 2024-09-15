import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/course/course_bloc.dart';

import '../models/course.dart';

import '../widgets/course/course_cards_List_widget.dart';

class ClickedCoursesPage extends StatelessWidget {
  static const String id = 'ClickedCoursesPage';
  final List<String> clickedCourseIds;

  const ClickedCoursesPage({
    required this.clickedCourseIds,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var futureCall = context.read<CourseBloc>().fetchCourses(clickedCourseIds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interested Courses',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Course>>(
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
              useFixedCrossAxisCount: false,
            );
          },
        ),
      ),
    );
  }
}
