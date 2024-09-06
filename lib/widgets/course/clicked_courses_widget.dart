import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../pages/course_details_page.dart';

import '../../models/course.dart';

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
        .where('is_clicked', isEqualTo: true)
        .orderBy('created_date', descending: true)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueCourses = widget.clickedCourses.toSet().toList();

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

          return GridView.count(
            childAspectRatio: 1.5,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(uniqueCourses.length, (index) {
              final course = uniqueCourses[index];

              return InkWell(
                onTap: () async {
                  if (!mounted) return;

                  Navigator.pushNamed(
                    context,
                    CourseDetailsPage.id,
                    arguments: course,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(uniqueCourses[index].title ?? 'No Title'),
                  ),
                ),
              );
            }),
          );
        });
  }
}
