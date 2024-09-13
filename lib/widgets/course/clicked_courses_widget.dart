import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/course.dart';

import 'course_cards_List_widget.dart';

class ClickedCoursesWidget extends StatefulWidget {
  final List<Course> clickedCourses;

  ClickedCoursesWidget({required this.clickedCourses, super.key});

  @override
  State<ClickedCoursesWidget> createState() => _ClickedCoursesWidgetState();
}

class _ClickedCoursesWidgetState extends State<ClickedCoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  final int index = 0;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(
            child: Text('No categories found'),
          );
        }

        return CourseCardsListWidget(
          courses: widget.clickedCourses,
          useFixedCrossAxisCount: true,
        );
      },
    );
  }
}
